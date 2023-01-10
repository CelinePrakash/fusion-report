# pull base image
FROM condaforge/mambaforge:4.14.0-0

# who maintains this image
LABEL maintainer="Celine Prakash (celine.prakash@ccri.at)"
LABEL description=" RNA-seq pipeline fusion-report v2.1.5 + mitelman fix from Clinical-Genomics:mittelman_fix + added tool CICERO"

# copy conda yaml env
COPY rnaseq_fusion_report_v2.1.5_mitelman_fix_add_tool_cicero_env_explicit.yaml /tmp/rnaseq_fusion_report_v2.1.5_mitelman_fix_add_tool_cicero_env_explicit.yaml
# copy git directory

# install mamba env using yaml file
# specifying --name overrides whatever name may be in the .yaml file
RUN mamba create --name=fusion_report --file=/tmp/rnaseq_fusion_report_v2.1.5_mitelman_fix_add_tool_cicero_env_explicit.yaml 
RUN mamba clean --all --yes

# Configure activation of the new env
#   conda activate base is already part of ~/.bashrc
#RUN echo "conda activate fusion_report" >> ~/.bashrc
#SHELL ["/bin/bash", "--login", "-c"]

RUN echo "conda activate fusion_report" >> ~/.bashrc 

ENV PATH /opt/conda/envs/fusion_report/bin:$PATH

# make new conda env as default:
ENV CONDA_DEFAULT_ENV fusion_report

COPY . /tmp/.

WORKDIR "/tmp"

#using conda environment and installing from source
RUN which python3 && python3 setup.py install

ENTRYPOINT [ "tini","-s", "--" ]