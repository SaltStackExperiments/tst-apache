{% set version = '1.5.2' %}
# /srv/salt/apache-base/init.sls
# run this state with salt <minion_id> state.apply apache-base
httpd:
   pkg.installed: 
     - name: httpd

index_conf_in_place:
  test.configurable_test_state:
    - name: index_conf_in_place
    - changes: True
    - result: True
    - comment: stand-in for default

# index_conf_in_place:
#   file.managed:
#     - name: /etc/httpd/conf/httpd.conf
#     - source: salt://apache-base/files/httpd.conf
#     - template: jinja
#     - port: 80
#     - user: apache
#     - group: apache

httpd_running:
  service.running:
    - name: httpd
    - restart: true
    - enabled: true
    - watch:
      - index_conf_in_place

# check existence of and contents of status_txt
file_status_txt_managed:
  file.managed:
      - name: /var/www/html/
      - source: salt://apache-base/files/app/
      - template: jinja
      - version: {{ version }}


verify_application_status:
  http.query:
    - name: 'http://{{ grains.get('ipv4')[1] }}/status.txt'
    - status: 200
    - match: 'version:{{ version }}'
    - require:
      - httpd_running
