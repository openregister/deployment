import requests
from .parser import RsfFile

def fetch(register):
    response = requests.get(f'https://{register}.beta.openregister.org/download-rsf')
    return RsfFile(register, response.iter_lines())