FROM jupyter/base-notebook

USER root
RUN apt-get update \
  && apt-get install -yq --no-install-recommends graphviz git vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER $NB_USER

RUN conda update conda
RUN conda install --yes \
    blosc==1.14.4 \
    python-blosc==1.5.1 \
    cytoolz \
    dask==0.19.4 \
    nomkl \
    numpy==1.15.1 \
    pandas==0.23.4 \
    ipywidgets \
    jupyterlab==0.35.1 \
    conda-forge::dask-ml \
    conda-forge::tpot \
    py-xgboost \
    fastparquet \
    gcsfs \
    matplotlib \
    && conda clean -tipsy
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager dask-labextension

RUN pip install --no-cache-dir --no-dependencies \
    graphviz \
    git+https://github.com/dask/dask-xgboost

USER root
COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh
RUN mkdir /opt/app
COPY examples/ /home/$NB_USER/examples
RUN chown -R $NB_USER /home/$NB_USER/examples
USER $NB_USER

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
CMD ["start.sh", "jupyter", "lab"]
