{% set version = pillar.get('app_version') %}
# apache-base/init.sls
# run this state with salt <minion_id> state.apply apache-base


httpd:
   pkg.installed: 
     - name: httpd

# check existence of and contents of /etc/httpd/conf/httpd.conf
file_/etc/httpd/conf/httpd.conf_managed:
  file.managed:
      - name: /etc/httpd/conf/httpd.conf
      - source: salt://apache-base/files/httpd.conf 
      - require:
        - httpd

httpd_running:
  service.running:
    - name: httpd
    - restart: true
    - enabled: true
    - watch:
      - file_/etc/httpd/conf/httpd.conf_managed

# check existence of and contents of status_txt
file_application_in_place:
  file.recurse:
      - name: /var/www/html/
      - source: salt://apache-base/files/app/
      - template: jinja


verify_application_status:
  http.query:
    - name: 'http://{{ grains.get('ipv4')[1] }}/status.txt'
    - status: 200
    - match: 'version:{{ version }}'
    - require:
      - httpd_running
      - file_application_in_place
