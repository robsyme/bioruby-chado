The Saccharomyces cerevisiae gff is provided to be loaded into a test chado database.

I'm bootstrapping the library with the help of bioperl, as I don't want to library to completely replicate the bioperl efforts, just to provide a convenient interface between BioRuby and 


/usr/bin/pg_restore --port 5432 --username rob --dbname chado_test --verbose "/data/Backups/Chado/acnfp_chado_00_00.backup"

time gmod_bulk_load_gff3.pl --organism yeast -gfffile saccharomyces_cerevisiae.gff.sorted --fastafile saccharomyces_cerevisiae.gff.sorted.fasta --dbname chado_test --dbpass grayishgymnosperm --dbuser rob --noexon --analysis 1> db_load.stderr 2>&1



