{% set version = pillar.get('app_version') %}
# apache-base/init.sls
# run this state with salt <minion_id> state.apply apache-base


httpd_installed:
   pkg.installed: 
     - name: httpd

# check existence of and contents of /etc/httpd/conf/httpd.conf
file_/etc/httpd/conf/httpd.conf_managed:
  file.managed:
      - name: /etc/httpd/conf/httpd.conf
      - source: salt://apache-base/files/httpd.conf 
      - require:
        - httpd_installed


# check existence of and contents of status_txt
file_application_in_place:
  file.recurse:
      - name: /var/www/html/
      - source: salt://apache-base/files/app/
      - template: jinja

httpd_running:
  service.running:
    - name: httpd
    - restart: true
    - enable: true
    - watch:
      - file_/etc/httpd/conf/httpd.conf_managed

verify_application_status:
  http.query:
    - name: 'http://{{ grains.get('ipv4')[1] }}/status.txt'
    - status: 200
    - match: 'version:{{ version }}'
    - onchange:
      - httpd_running
      - file_application_in_place
