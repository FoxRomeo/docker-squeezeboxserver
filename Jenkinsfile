pipeline {
	agent {
		label 'master'
	}
	parameters {
		string(name: 'OVERRIDE', defaultValue: 'latest', description: 'Version to use (leave "latest" to use latest release)', trim: true)
	}
	triggers {
		cron('H H(4-16) * * 3') // normal build
	}
	options {
		skipStagesAfterUnstable()
		disableResume()
		timestamps()
		timeout(time: 4, unit: 'HOURS') 
	}
	environment {
		DEBUG = "1"
		REGISTRY = "intrepidde"
		EMAIL_TO = 'olli.jenkins.prometheus@intrepid.de'
		NAMEBASE = "squeezeboxserver"
		SECONDARYREGISTRY = "nexus.intrepid.local:4000"
		BASETYPE = "-empty-"
		SOFTWAREVERSION = """${sh(
			returnStdout: true,
			script: '/bin/bash ./get_version.sh'
			).trim()}"""
		SOFTWARESTRING = "<<LMSVERSION>>"
		TARGETVERSION = "${SOFTWAREVERSION}"
	}
	stages {
		stage('x86') {
			agent {
				label 'x86 && Docker && build-essential'
			}
			options {
				timeout(time: 1, unit: 'HOURS') 
			}
			environment {
				NAME = "${NAMEBASE}"
				SECONDARYNAME = "${NAME}"
				BASECONTAINER = "centos:8"
			}
			stages {
				stage('Build'){
					environment {
						ACTION = "build"
					}
					steps {
						sh '/bin/bash ./action.sh'
					}
				}
				stage('Push'){
					environment {
						ACTION = "push"
					}
					steps {
						sh '/bin/bash ./action.sh'
					}
				}
			}
		}
	}
	post {
		always {
			cleanWs()
		}
		success {
			echo 'BUILD OK'
		}
		failure {
			emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}',
			to: EMAIL_TO,
			subject: 'Build failed in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
		}
		unstable {
			emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}',
			to: EMAIL_TO,
			subject: 'Unstable build in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
		}
		changed {
			emailext body: 'Check console output at $BUILD_URL to view the results.',
			to: EMAIL_TO,
			subject: 'Jenkins build is back to normal: $PROJECT_NAME - #$BUILD_NUMBER'
		}
	}
}
