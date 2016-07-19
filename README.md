# drupalcrm

**1. Accessing the aws instance through SSH**

* Download the [.pem file](https://github.com/laurosn/drupalcrm/blob/master/drupalcrm/files/keys/workforus%20(1).pem)
* ```ssh -i workforus\ \(1\).pem ubuntu@ec2-52-67-92-118.sa-east-1.compute.amazonaws.com ```


**2. Accessing the website**

* On web browser, access this [link](https://ec2-52-67-92-118.sa-east-1.compute.amazonaws.com)
* User: *admin* Password: *admin*


**3. Accessing the configuration**

* Access the amazon instance through ssh ```ssh -i workforus\ \(1\).pem ubuntu@ec2-52-67-92-118.sa-east-1.compute.amazonaws.com ```
* Configuration directories
  * ```/etc/nginx``` - Nginx configuration (generated from puppet module) 
