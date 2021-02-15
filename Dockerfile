FROM redmine:4.1.1

# AWS Fargate doesn't support persistent file bind mounts, which is why
# here we're creating an overlay volume that can host all files that will
# be symlinked into directories with other pre-existing files.
VOLUME /usr/src/redmine/config/overlay

# database.yml contains DB config. While the upstream container supports setting
# up DB via environment variables, they regret ever implementing that option:
# https://github.com/docker-library/redmine/pull/190#issuecomment-579924343
#
# I agree and I think that it's harmful that so many containers opt to diverge from
# configuration workflow designed and documented by the application maintainers.
RUN ln -s /usr/src/redmine/config/overlay/database.yml /usr/src/redmine/config

# configuration.yml stores all config options that a) aren't part of DB config and
# b) aren't stored in the database. For example, SMTP authentication settings.
RUN ln -s /usr/src/redmine/config/overlay/configuration.yml /usr/src/redmine/config
