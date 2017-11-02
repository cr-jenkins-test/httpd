def altiNode(Closure cl) {
    withCredentials([string(credentialsId: 'artifactory-jenkins-dev', variable: 'ARTIFACTORY_API_KEY')]) {
        withEnv(['CI=true', "BERKSHELF_PATH=${env.WORKSPACE}/.berkshelf", 'ALTISCALE_BERKS_ARTIFACTORY=true']) {
            node('cookbook') {
                container('alti-pipeline') {
                    cl()
                }
            }
        }
    }
}

def altiPipelineVersion = '4.9.0'

podTemplate(label: 'cookbook', imagePullSecrets: ['artifactory-pull'], containers: [
  containerTemplate(name: 'alti-pipeline', image: "altiscale-docker-dev.jfrog.io/alti_pipeline:testing" /* "altiscale-docker-dev.jfrog.io/alti_pipeline:${altiPipelineVersion}" */, alwaysPullImage: false /* true */, command: "/bin/sh -c \"trap 'exit 0' TERM; sleep 2147483647 & wait\""),
]) {
    // stage('Wat') {
    //     withCredentials([string(credentialsId: 'artifactory-jenkins-dev', variable: 'ARTIFACTORY_API_KEY')]) {
    //         echo env.ARTIFACTORY_API_KEY[0..10]
    //         altiNode {
    //             sh 'env'
    //         }
    //     }
    //     altiNode {
    //         sh 'env'
    //     }
    // }
    stage('Check') {
        altiNode {
            checkout scm
            def gemfile = readFile('Gemfile')
            if(gemfile =~ /gem.*alti_pipeline.*\b${altiPipelineVersion[0]}\./) {
                echo "Gemfile is compatible with alti_pipeline ${altiPipelineVersion}"
            } else {
                error "Gemfile is not compatible with alti_pipeline ${altiPipelineVersion}:\n"+gemfile
            }
        }
    }
    stage('Test') {
        parallel(
            'Lint': {
                altiNode {
                    checkout scm
                    sh 'rm -f Gemfile Gemfile.lock'
                    sh 'rake style'
                }
            },
            'Unit Tests': {
                altiNode {
                    checkout scm
                    try {
                        sh 'rm -f Gemfile Gemfile.lock'
                        sh 'rake spec'
                    } finally {
                        junit 'results.xml'
                    }
                }
            },
            'Integration Tests': {
                altiNode {
                    checkout scm
                    sh 'rm -f Gemfile Gemfile.lock'
                    sh 'kitchen test --destroy always'
                }
            }
        )
    }
    stage('Publish') {
        echo 'TODO Publishing ...'
    }

}
