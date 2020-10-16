FROM nhsdigitalmait/tkw-x:20200803-SNAPSHOT
RUN useradd -rm -u 1001 service
RUN mkdir /home/service/data/ && chown service:service /home/service/data/
VOLUME /home/service/data
VOLUME /home/service/fhir
VOLUME /home/service/certs
COPY . /home/service/TKW/config/FHIR_111_UEC
WORKDIR /home/service/TKW/config/FHIR_111_UEC
RUN sh set-all-configurations.sh

ENV trustStore=default
ENV trustStorePassword=default
ENV keyStore=default
ENV keyStorePassword=default
USER service
CMD ["bash", "runtkwfhirvalidator.sh"]

