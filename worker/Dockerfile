FROM continuumio/miniconda3:4.5.4

# Dumb init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda update conda
RUN conda install --yes \
    blosc==1.14.4 \
    python-blosc==1.5.1 \
    cytoolz \
    dask==0.19.4 \
    nomkl \
    numpy==1.15.1 \
    pandas==0.23.4 \
    conda-forge::dask-ml \
    conda-forge::tpot \
    py-xgboost \
    fastparquet \
    gcsfs \
    && conda clean -tipsy

RUN pip install --no-cache-dir --no-deps \
    git+https://github.com/dask/dask-xgboost

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]
