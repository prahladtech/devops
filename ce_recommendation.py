#!/usr/bin/env python

from boto3.session import Session
import boto3

AWS_REGION = "ap-southeast-1"
AWS_COST_EXPLORER_SERVICE_KEY = "ce"

def main():
    session = Session(profile_name='<saml_profile>')
    cost_explorer = session.client(AWS_COST_EXPLORER_SERVICE_KEY, AWS_REGION)

    token = None
    result = []
    while True:
        kwargs = {}
        if token:
            kwargs = {"NextPageToken": token}
    	response = cost_explorer.get_rightsizing_recommendation(
		Filter={
			'Tags': {
                       	'Key': 'user:<Tag Key>',
                        	'Values': [ '<Value>' ]
                   	}
		},
		Service='AmazonEC2',
    		PageSize=5000,
                **kwargs)
	#print response
	result += response["RightsizingRecommendations"]
	#print response["RightsizingRecommendations"]
	token = response.get("NextPageToken", None)
        if not token:
            break
    print result
if __name__ == "__main__":
    main()

