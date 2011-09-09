The Saccharomyces cerevisiae gff is provided to be loaded into a test chado database.

I'm bootstrapping the library with the help of bioperl, as I don't want to library to completely replicate the bioperl efforts, just to provide a convenient interface between BioRuby and 


createdb chado_test
pg_restore --host localhost --port 5432 --username $USER --dbname chado_test --verbose "test/data/chado_test.backup"


