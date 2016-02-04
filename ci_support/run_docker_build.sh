#!/usr/bin/env bash

# NOTE: This script has been automatically generated by github.com/conda-forge/conda-smithy/...

FEEDSTOCK_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
RECIPE_ROOT=$FEEDSTOCK_ROOT/recipes

docker info

config=$(cat <<CONDARC

channels:

 - janschulz

 - defaults

conda-build:
 root-dir: /feedstock_root/build_artefacts

show_channel_urls: True

CONDARC
)

cat << EOF | docker run -i \
                        -v ${RECIPE_ROOT}:/recipe_root \
                        -v ${FEEDSTOCK_ROOT}:/feedstock_root \
                        -a stdin -a stdout -a stderr \
                        pelson/obvious-ci:latest_x64 \
                        bash || exit $?

# The BINSTAR secure variable is set by 'conda smithy register-ci' via a web request.
export BINSTAR_TOKEN=${BINSTAR_TOKEN}
export PYTHONUNBUFFERED=1

echo "$config" > ~/.condarc
# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artefacts.
conda clean --lock

conda info


conda install -n root --quiet -c conda-forge --yes conda-build-all conda-build anaconda-client jinja2 setuptools

conda buildall /recipe_root --no-inspect-conda-bld-directory \
   --upload-channels "janschulz/channel/dev"\
   --inspect-channels "janschulz/channel/dev"

EOF
