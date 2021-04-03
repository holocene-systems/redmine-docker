# Default Redmine container flavor uses WEBrick :(
FROM redmine:4.2.0-passenger

# Install PurpleMine 2 theme.
ENV PURPLEMINE2_VERSION 2.14.0
ENV PURPLEMINE2_DOWNLOAD_BLAKE2 3eb895639bf1a4d03297e73d2b31e17f99c607453e6d0f406f6517e1ffd90ff3410dbb00c7c1ae3572216993ddd6fbd1ced7312122e773ca748b16c912198f4e

RUN set -o errexit -o nounset -o xtrace; \
    wget --output-document=PurpleMine2.tar.gz https://github.com/mrliptontea/PurpleMine2/archive/v${PURPLEMINE2_VERSION}.tar.gz; \
    echo "${PURPLEMINE2_DOWNLOAD_BLAKE2} PurpleMine2.tar.gz" | b2sum --check; \
    mkdir public/themes/PurpleMine2; \
    tar --directory=public/themes/PurpleMine2 --extract --file=PurpleMine2.tar.gz --strip-components=1; \
    rm PurpleMine2.tar.gz

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
RUN ln --symbolic /usr/src/redmine/config/overlay/database.yml /usr/src/redmine/config; \
# configuration.yml stores all config options that a) aren't part of DB config and
# b) aren't stored in the database. For example, SMTP authentication settings.
    ln --symbolic /usr/src/redmine/config/overlay/configuration.yml /usr/src/redmine/config
