#!/usr/bin/env python
# encoding: utf-8
# Copyright (c) 2015 Meng Zhuo <mengzhuo1203@gmail.com>

import json
import requests
import argparse
import datetime
from string import Template

def get_repo_list(username="mengzhuo"):
    """
    Get the lastest 100 active repos of user
    """
    return requests.get("https://api.github.com/users/%s/repos" % username,
            params={"sort":"push", "type":"all", "per_page":100}).json()

def caculate_impact(repo=None):
    """
    Fork: 300 each
    Star: 100 each
    Watch: 50 each
    Size: 0.01 each
    Fork From others: 10
    """
    
    if repo.get("fork"):
        is_contributor = 10
    else:
        is_contributor = 0

    return sum([200  * repo.get("forks_count",0),
                100  * repo.get("stargazers_count", 0),
                50   * repo.get("watchers_count",0),
                0.01 * repo.get("size",0),
                is_contributor
                ])

def generate_data(repo_list=None):
    
    filter_list = ("name", "html_url", "language", "forks_count",
                   "stargazers_count", "watchers_count", "size")
    # keep the order
    result = []
    for repo in repo_list:
        data = {k:v for k,v in repo.items() 
                if k in filter_list}
        data['impact'] = caculate_impact(repo)
        result.append(data)
    
    return result

def main():

    parser = argparse.ArgumentParser(version="Github Profile 0.1-beta")
    parser.add_argument("-u", action="store", dest="username", const="mengzhuo",
                        help="Your Github Account Name", nargs="?", default="mengzhuo")
    parser.add_argument("-o", action="store", dest="output", const="index.html",
                        help="Output file", nargs="?", default="index.html")
    parser.add_argument("-i", action="store", dest="input", const="default.tpl",
                        help="Input Template file i.e. include $data", nargs="?",
                        default="default.tpl")
    
    args = parser.parse_args()

    data = json.dumps(generate_data(get_repo_list(args.username)))

    if args.input.lower().startswith("http"):
        tpl = Template(requests.get(args.input).content) 
    else:
        with open(args.input) as tpl_file:
            tpl = Template(tpl_file.read())

    with open(args.output, "wb") as of:
        of.write(tpl.substitute(username=args.username,
                                data=data,
                                generate_time=datetime.datetime.utcnow().isoformat()))
       
if __name__ == '__main__':
    main()
