docker_repo_added:
  pkgrepo.managed:
    - name: docker-ce
    - enabled: True
    - baseurl: https://download.docker.com/linux/centos/docker-ce.repo
    - refresh: True

docker-installed:
   pkg.installed: 
     - names:
        - yum-utils
        - device-mapper-persistent-data
        - lvm2
        - docker-ce
        - docker-ce-cli
        - containerd.io

pip_installed:
  pkg.installed:
    - name: python-pip

docker_py_installed:
  pip.installed:
    - name: "docker-py>=1.4.0"
    - require:
      - pip_installed

