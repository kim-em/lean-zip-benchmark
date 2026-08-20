# Corpus Provenance

## Canterbury Corpus (`canterbury/`, committed)

The 11 files under `canterbury/` are the standard Canterbury Corpus,
fetched from https://corpus.canterbury.ac.nz/ (`cantrbry.tar.gz`) and
verified file-by-file against the SHA-256 checksums recorded in
[`fetch_corpora.sh`](../fetch_corpora.sh). The corpus has been
distributed since 1997 as a public benchmark set for compression
research and is universally redistributed by compression projects for
that purpose; the corpus site does not publish formal license text, and
individual members (e.g. `alice29.txt`, `plrabn12.txt` from Project
Gutenberg; `kennedy.xls`; `sum`) retain their original copyright
status. They are included here solely as benchmark inputs. If a
formal-redistribution concern ever arises, delete the directory and let
`fetch_corpora.sh` materialize it on demand instead.

## Silesia Corpus (not committed)

Silesia (https://sun.aei.polsl.pl/~sdeor/index.php?page=silesia) is
fetched on demand by `fetch_corpora.sh` into this gitignored cache and
never committed.
