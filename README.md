# europeana-test-env

Build a fully functional [Vagrant](https://www.vagrantup.com/) test environment for the Europeana [Portal](https://github.com/europeana/portal)/[API](https://github.com/europeana/api2).

### Services
* [MongoDB](http://www.mongodb.org/) document database, with content (accessible via port 27027) 
* [PostgreSQL](http://www.postgresql.org/) relational database, with content (accessible via port 15432)
* [Neo4j](http://neo4j.com/) graph database, with content (accessible via port 17474)
* [Apache Solr](http://lucene.apache.org/solr/) search engine, with content (accessible via port 18080/18983)
* [Apache Tomcat](http://tomcat.apache.org/) web server, required for the API (accessible via port 18080)
* [Europeana API](https://github.com/europeana/api2) (and [CoreLib](https://github.com/europeana/corelib))

### Software
*  Java 7, required for Solr
*  Git 1.9, required for retrieving the CoreLib/API code
*  Maven 3, required for building CoreLib/API

## Installation
Clone the repository

```bash
git clone https://github.com/bramfoo/europeana-test-env.git
cd europeana-test-env
```

Run vagrant

```bash
vagrant up
```

##Examples
### MongoDB
(Requires a MongoDB client installed on the host machine)

```bash
mongo --port 27027
>show dbs
```

### PostgreSQL
(Requires a PSQL client installed on the host machine)

```bash
psql -h localhost -p 15432 -d europeana -U europeana
europeana=> SELECT * from users;
```

### Neo4j
Point your browser to: [http://localhost:17474/browser/](http://localhost:17474/browser/)
### Solr
Point your browser to: [http://localhost:18080/solr/#/collection1/query](http://localhost:18080/solr/#/collection1/query)
### Tomcat
Point your browser to: [http://localhost:18080/manager](http://localhost:18080/manager) (admin/admin)
### API
Point your browser to: [http://localhost:18080/api/v2/](http://localhost:18080/api/v2/)

##To do
* Add content for
  * MongoDB
  * Neo4j
  * Solr
