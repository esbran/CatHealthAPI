

import requests
import pydicom
from pathlib import Path
from urllib3.filepost import encode_multipart_formdata, choose_boundary
from azure.identity import DefaultAzureCredential

dicom_service_name = "catdicom2"
path_to_dicoms_dir = "https://cathealth.blob.core.windows.net/dicom/"

base_url = f"https://catapi2-catdicom2.dicom.azurehealthcareapis.com/v1.0-prerelease"

study_uid = "1.2.826.0.1.3680043.8.498.13230779778012324449356534479549187420"; #StudyInstanceUID for all 3 examples
series_uid = "1.2.826.0.1.3680043.8.498.45787841905473114233124723359129632652"; #SeriesInstanceUID for green-square and red-triangle
instance_uid = "1.2.826.0.1.3680043.8.498.47359123102728459884412887463296905395"; #SOPInstanceUID for red-triangle
body_uid = "1.2.826.0.1.3680043.8.1055.1.20111103112244831.40200514.30965937";

from azure.identity import DefaultAzureCredential
credential = DefaultAzureCredential()

print(credential.credentials) # this can be used to find the index of the AzureCliCredential
token = credential.credentials[4].get_token('https://dicom.healthcareapis.azure.com')
bearer_token = f'Bearer {token.token}'

def encode_multipart_related(fields, boundary=None):
    if boundary is None:
        boundary = choose_boundary()

    body, _ = encode_multipart_formdata(fields, boundary)
    content_type = str('multipart/related; boundary=%s' % boundary)

    return body, content_type 