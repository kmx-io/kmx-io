
YML = \
	gitlab.yml \
	secrets.yml

all: ${YML}

GITLAB_YML = \
	gitlab.yml.d/01_production_gitlab.yml \
	gitlab.yml.d/02_email.yml \
	gitlab.yml.d/03_artifacts.yml \
	gitlab.yml.d/04_external_diffs.yml \
	gitlab.yml.d/05_git_lfs.yml \
	gitlab.yml.d/06_uploads.yml \
	gitlab.yml.d/07_packages.yml \
	gitlab.yml.d/08_dependency_proxy.yml \
	gitlab.yml.d/09_pages.yml \
	gitlab.yml.d/10_mattermost.yml \
	gitlab.yml.d/11_gravatar.yml \
	gitlab.yml.d/12_sidekiq.yml \
	gitlab.yml.d/13_cron_jobs.yml \
	gitlab.yml.d/14_ee_cron_jobs.yml \
	gitlab.yml.d/15_registry.yml \
	gitlab.yml.d/16_sentry.yml \
	gitlab.yml.d/17_geo.yml \
	gitlab.yml.d/18_feature_flags.yml \
	gitlab.yml.d/19_gitlab_ci.yml \
	gitlab.yml.d/20_ldap.yml \
	gitlab.yml.d/21_smartcard.yml \
	gitlab.yml.d/22_kerberos.yml \
	gitlab.yml.d/23_omniauth.yml \
	gitlab.yml.d/24_shared.yml \
	gitlab.yml.d/25_gitaly.yml \
	gitlab.yml.d/26_repositories.yml \
	gitlab.yml.d/27_backup.yml \
	gitlab.yml.d/28_pseudonymizer.yml \
	gitlab.yml.d/29_gitlab_shell.yml \
	gitlab.yml.d/30_workhorse.yml \
	gitlab.yml.d/31_elasticsearch.yml \
	gitlab.yml.d/32_git.yml \
	gitlab.yml.d/33_webpack.yml \
	gitlab.yml.d/34_monitoring.yml \
	gitlab.yml.d/35_prometheus.yml \
	gitlab.yml.d/36_shutdown.yml \
	gitlab.yml.d/37_extra.yml \
	gitlab.yml.d/38_rack_attack.yml

gitlab.yml: ${GITLAB_YML}
	cat ${GITLAB_YML} > $@
	chmod 644 $@

SECRETS_YML = \
	secrets.yml.d/01_head.yml \
	secrets.yml.d/02_secret.yml \
	secrets.yml.d/03_tail.yml

secrets.yml: ${SECRETS_YML}
	cat ${SECRETS_YML} > $@
	chmod 400 $@

clean:
	rm -f ${YML}

.PHONY: all clean
