FROM redmine:4.1

VOLUME /usr/src/redmine/config-overlay

RUN ln -s /usr/src/redmine/config-overlay/configuration.yml \
          /usr/src/redmine/config/configuration.yml; \
    ln -s /usr/src/redmine/config-overlay/database.yml \
          /usr/src/redmine/config/database.yml;
