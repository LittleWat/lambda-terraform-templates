from urllib.request import Request, urlopen


def lambda_handler(event, context):
    url = 'http://checkip.amazonaws.com'
    with urlopen(Request(url)) as response:
        print(response.read().decode('utf-8'))
