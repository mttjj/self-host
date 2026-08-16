# Comics

## Organize Master Copies
1. Download PDFs
2. Organize PDFs into series and rename the files using the Komga recommended formats
    - For single issues: `/Series Name/Series name #iss.pdf`. ex: `/Daredevil (1964)/Daredevil (1964) #171.pdf`
    - For collections or series with volumes: `/Series Name/Volume # - Volume Title.pdf`. ex: `The EC Artists' Library/Volume #11 - Aces High.pdf`
3. After the files are organized and renamed **but before making any sort of metadata changes**, copy them to `/Volumes/Media/Archives/Books/Comics/Originals (PDFs)` for archival and rollback purposes

## Conversion
PDF Master files should be converted to CBZ. (Don't convert PDFs that are just scans of magazines or comics.)

Use the `convert-comics.sh` script to convert all PDFs in a directory:

```bash
./convert-comics.sh /path/to/comics/directory
```

The script will:
- Recursively find all PDFs in the specified directory
- Convert each PDF to CBZ format (150 DPI, PNG images)
- Skip files that have already been converted
- Place the CBZ file in the same directory as the source PDF

**First time setup:** After cloning this repo, initialize the submodule:
```bash
git submodule update --init --recursive
```

## Metadata Preparation