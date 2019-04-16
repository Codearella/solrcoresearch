

REM ===Try to start the solr nodes, in case they have been stopped.===
REM ===..\..\bin\solr.cmd start -c -p 8983 -s example/cloud/node1/solr
REM ===..\..\bin\solr.cmd start -c -p 7574 -s example/cloud/node2/solr -z localhost:9983

REM ===Create a collection called movies.====
call ..\..\bin\solr create -c movies -s 2 -rf 2

REM ===Turn off autoCreateFields, since we will be creating fields manually.===
call ..\..\bin\solr config -c movies -p 8983 -action set-user-property -property update.autoCreateFields -value false

REM ===Define the fields corresponding with the table headers.===
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"genres\",\"type\":\"text_general\",\"stored\":true,\"multiValued\":true}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"production_companies\",\"type\":\"text_general\",\"stored\":true,\"multiValued\":true}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"budget\",\"type\":\"plong\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"popularity\",\"type\":\"pfloat\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"revenue\",\"type\":\"plong\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"runtime\",\"type\":\"pint\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"vote_average\",\"type\":\"pfloat\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"vote_count\",\"type\":\"pint\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"original_language\",\"type\":\"text_general\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"overview\",\"type\":\"text_general\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"tagline\",\"type\":\"text_general\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"title\",\"type\":\"text_general\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\":{\"name\":\"release_date\",\"type\":\"pdate\",\"stored\":true,\"multiValued\":false}}" http://localhost:8983/solr/movies/schema
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-copy-field\" : {\"source\":\"*\",\"dest\":\"_text_\"}}" http://localhost:8983/solr/movies/schema

REM ===Load the data===
java -jar -Dc=movies -Dparams="f.genres.split=true&f.production_companies.split=true&f.genres.separator=|&f.production_companies.separator=|" -Dauto ..\exampledocs\post.jar ..\movies\movies.csv
