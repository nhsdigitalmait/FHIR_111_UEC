FROM nhsdigitalmait/tkw-x:20201120
RUN useradd -rm -u 1000 service
RUN mkdir /home/service/data/ && chown service:service /home/service/data/
VOLUME /home/service/data
VOLUME /home/service/fhir
VOLUME /home/service/certs
COPY . /home/service/TKW/config/FHIR_111_UEC
WORKDIR /home/service/TKW/config/FHIR_111_UEC
RUN mkdir /home/service/TKW/config/FHIR_111_UEC/simulator_saved_messages/
RUN mkdir /home/service/TKW/config/FHIR_111_UEC/messages_for_validation/
RUN sh set-all-configurations.sh

ENV trustStore=default
ENV trustStorePassword=default
ENV keyStore=default
ENV keyStorePassword=default
USER service
CMD ["bash", "runtkwfhirvalidator.sh"]

