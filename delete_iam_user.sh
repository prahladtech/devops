#!/bin/bash

user=$1
echo "User: $user"

user_policies=$(awsudo -u <saml_profile> -- aws iam list-user-policies --user-name $user --query 'PolicyNames[*]' --output text)

echo "Deleting user policies: $user_policies"
for policy in $user_policies ;
do
  echo "aws iam delete-user-policy --user-name $user --policy-name $policy"
  awsudo -u <saml_profile> -- aws iam delete-user-policy --user-name $user --policy-name $policy
done

user_attached_policies=$(awsudo -u <saml_profile> -- aws iam list-attached-user-policies --user-name $user --query 'AttachedPolicies[*].PolicyArn' --output text)

echo "Detaching user attached policies: $user_attached_policies"
for policy_arn in $user_attached_policies ;
do
  echo "aws iam detach-user-policy --user-name $user --policy-arn $policy_arn"
  awsudo -u <saml_profile> -- aws iam detach-user-policy --user-name $user --policy-arn $policy_arn
done

user_groups=$(awsudo -u <saml_profile> -- aws iam list-groups-for-user --user-name $user --query 'Groups[*].GroupName' --output text)

echo "Detaching user attached group: $user_groups"
for group in $user_groups ;
do
  echo "awsudo -u <saml_profile> -- aws iam remove-user-from-group --user-name $user --group-name $group"
  awsudo -u <saml_profile> -- aws iam remove-user-from-group --user-name $user --group-name $group
done

user_access_keys=$(awsudo -u <saml_profile> -- aws iam list-access-keys --user-name $user --query 'AccessKeyMetadata[*].AccessKeyId' --output text)

echo "Deleting user access keys: $user_accces_keys"
for key in $user_access_keys ;
do
  echo "awsudo -u <saml_profile> -- aws iam delete-access-key --user-name $user --access-key-id $key"
  awsudo -u <saml_profile> -- aws iam delete-access-key --user-name $user --access-key-id $key
done

user_mfa_device=$(awsudo -u <saml_profile> -- aws iam list-mfa-devices --user-name $user --query 'MFADevices[*].SerialNumber' --output text)

echo "deactivate-mfa-device MFA device: $user_mfa_device"

for device in $user_mfa_device ;
do
  echo "awsudo -u <saml_profile> -- aws iam deactivate-mfa-device --user-name $user --serial-number $device"
  awsudo -u <saml_profile> -- aws iam deactivate-mfa-device --user-name $user --serial-number $device
done

echo "delete-mfa-device MFA device: $user_mfa_device"

for device in $user_mfa_device ;
do
  echo "awsudo -u <saml_profile> -- aws iam delete-virtual-mfa-device --serial-number $device"
  awsudo -u <saml_profile> -- aws iam delete-virtual-mfa-device --serial-number $device
done

user_ssh_key=$(awsudo -u <saml_profile> -- aws iam list-ssh-public-keys --user-name $user --query 'SSHPublicKeys[*].SSHPublicKeyId' --output text)

echo "Deleting ssh key for user: $user_ssh_key"

for ssh_key in $user_ssh_key;
do
  echo "awsudo -u <saml_profile> -- aws iam delete-ssh-public-key --user-name $user --ssh-public-key-id $ssh_key"
  awsudo -u <saml_profile> -- aws iam delete-ssh-public-key --user-name $user --ssh-public-key-id $ssh_key
done

echo "Deleting user login profile"
echo "awsudo -u <saml_profile> -- aws iam delete-login-profile --user-name $user"
awsudo -u <saml_profile> -- aws iam delete-login-profile --user-name $user

echo "Deleting user: $user"
echo "awsudo -u <saml_profile> -- aws iam delete-user --user-name $user"
awsudo -u <saml_profile> -- aws iam delete-user --user-name $user
