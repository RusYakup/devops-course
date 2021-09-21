from flask import Flask
from flask import request
import traceback
import logging
import sys
import os
import yaml

with open(os.path.join(os.path.dirname(__file__), "config.yml")) as configfile:
    config = yaml.safe_load(configfile)

logging.basicConfig(stream=sys.stdout, level=config.get("LOGLEVEL") if "LOGLEVEL" in config
                    else "DEBUG")


app = Flask("Animals sounds app")


@app.route('/', methods=['POST'])
def get_animals_sounds():
    try:
        request_args = request.get_json()
    except Exception:
        logging.error(f"Error during deserialize args. Exception: {traceback.format_exc()}")
        return "POST request args must be json", 500

    required_args = ('animal', 'sound', 'count')
    for arg in required_args:
        if arg not in request_args:
            return f'Required argument "{arg}" does not be empty', 500

    response = ''
    for item in range(request_args['count']):
        response += f"{request_args['animal']} says {request_args['sound']}\n"

    response += "Made with by Rustam"
    logging.info(f"Request with args {request_args} successfully handled")
    return response


if __name__ == '__main__':
    app.run(host=config.get("HOST", "localhost"),
            port=config.get("PORT", 5000),
            debug=True if config.get("LOGLEVEL") == "DEBUG" else False)