# subscript-rhel-y-server-extras-rpms:
#   cmd.run:
#     - name: "subscription-manager repos --enable=rhel-7-server-extras-rpms"

docker_repo_added:
  cmd.run:
    - name: "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"

# docker_repo_added:
#   pkgrepo.managed:
#     - name: docker-ce
#     - enabled: True
#     - baseurl: https://download.docker.com/linux/centos/docker-ce.repo
#     - refresh: True

docker-installed:
  pkg.installed: 
    - names:
      - yum-utils
      - httpd
      - device-mapper-persistent-data
      - lvm2
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - git
    - require:
      - docker_repo_added

pip_installed:
  pkg.installed:
    - name: python2-pip

docker_py_installed:
  pip.installed:
    - name: "docker-py>=1.4.0"
    - require:
      - pip_installed

docker_running:
  service.running:
    - name: docker
    - enable: True
    - require:
      - docker-installed


webhook_git_cloned:
  git.latest:
    - name: https://github.com/kajigga/python-github-webhooks.git
    - target: /var/python-github-webhooks

#docker build -t carlos-jenkins/python-github-webhooks python-github-webhooks
{% set docker_image = 'carlos-jenkins/python-github-webhooks' %}
{% set docker_tag = 'latest' %}
image_built:
  docker_image.present:
    - build: /var/python-github-webhooks
    - name: {{ docker_image }}
    - tag: {{ docker_tag }} 
    - watch: 
      - webhook_git_cloned

{% set webhooks_base_folder = '/var/webhooks/' %}
# check existence of and contents of /var/webhooks/config.js
file_/var/webhooks/config.js_managed:
  file.managed:
      - name: {{webhooks_base_folder}}config.json
      - source: salt://docker/files/config.json
      - makedirs: True

# check existence of and contents of /var/webhooks/hooks/
file_/var/webhooks/hooks/_managed:
  file.recurse:
      - name: {{webhooks_base_folder}}hooks/
      - source: salt://docker/files/hooks/
      - makedirs: True
      - file_mode: '0755'

#docker run -d --name webhooks -p 5000:5000 carlos-jenkins/python-github-webhooks
webhooks_running:
  docker_container.running:
    - image: {{ docker_image }}:{{ docker_tag }}
    - name: webhooks
    - ports:
      - "5000"
    - publish:
      - "5000:5000"
    - binds:
      - '{{ webhooks_base_folder }}hooks:/var/webhooks/hooks:Z'
      - '{{ webhooks_base_folder }}config.json:/app/config.json:Z'
    - environment:
        SSE_USERNAME:  {{ pillar.get('sse_username') }}
        SSE_PASSWORD:  {{ pillar.get('sse_password') }}
        SSE_HOST:  {{ pillar.get('sse_host') }}
        SSE_TGT_MASTER:  {{ pillar.get('sse_tgt_master') }}
        SSE_TGT_LIST:  {{ pillar.get('sse_tgt_list') }}
    - watch:
      - file_/var/webhooks/config.js_managed
      - file_/var/webhooks/hooks/_managed

# check existence of and contents of /etc/httpd/conf.d/webhook.conf
file_/etc/httpd/conf.d/webhook.conf_managed:
  file.managed:
      - name: /etc/httpd/conf.d/webhook.conf
      - source: salt://docker/files/webhook.conf
      - makedirs: True

apache_running:
  service.running:
    - name: httpd
    - enable: True
    - restart: True
    - watch:
      - file_/etc/httpd/conf.d/webhook.conf_managed

# ensure http query works with proper status, etc
http_check_port_query:
  http.query:
    - name: "http://localhost/webhook/status"
    - status: 200
    - method: POST
