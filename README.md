# is it down?
A script I made for monitoring my own website. If the response is anything but 200 then an email will be sent to me. The intention was to run this script periodically on a Raspberry PI.

* Note: uses gmail for smtp *

<h2>Setup</h2>

1. Setup a extraneous gmail account to use for sending message. 
2. Enable "Less Secure Apps" for your gmail account: <a href="https://support.google.com/accounts/answer/6010255?hl=en">link</a>
3. Fill in the params in "_config.yaml" and rename it to "config.yaml".
4. Run the script (if you want to have it run periodically, you'll have to do that yourself).

 
