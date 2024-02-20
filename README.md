# Wayback Archive Tool

The Wayback Archive Tool is a bash script that allows you to fetch archived snapshots of web pages from the Wayback Machine's CDX API. You can use this tool to retrieve snapshots for a single domain or a list of domains.

### install 
```
git clone https://github.com/abisheikMagesh/Waybackurl.git
cd Waybackurl
sudo chmod +x wayback.sh
```
## Usage
### Fetching snapshots for a single domain:

```bash
./wayback.sh -u domain_name [-p output_file_path]
```
### Fetching snapshots for a list  domain:

```
./wayback.sh -l domain_list_file [-p output_file_path]
```
