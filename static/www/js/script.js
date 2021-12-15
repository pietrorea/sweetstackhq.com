function scrollToForm() {
    const contactFormId = document.getElementById("contact-form");
    contactFormId.scrollIntoView();
}

function submitContactForm(e) {
    e.preventDefault();

    //const postURL = "http://localhost:9090/api/v1/contact";
    const postURL = `${window.location.href}api/v1/contact`;

    //TODO - add validation for email
    const email = valueForId("email");
    const firstName = valueForId("first_name");
    const lastName = valueForId("last_name");
    const phoneNumber = valueForId("phone_number");
    const companyName = valueForId("company_name");;
    const otherInfo = valueForId("other_info");

    const data = { email, firstName, lastName, phoneNumber, companyName, otherInfo };

    const request = new XMLHttpRequest();
    request.onreadystatechange = () => {
        if (request.readyState !== XMLHttpRequest.DONE)  {
            return;
        }

        // Always show a success screen.
        // Only use status here for logging.
        // Don't surface API errors (what a bad first impression!)

        const status = request.status;
        if ((status >= 200 && status < 400)) {
            //TODO - log success
            console.log("Request success");
        } else {
            //TODO - log failure
        }

        showSuccess();
    };

    request.open("POST", postURL);
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    request.send(JSON.stringify(data));
}

function showSuccess() {
    const contactFormContainer = document.getElementById("contact-form-input-container");
    const contactFormSuccessContainer = document.getElementById("contact-form-input-container-success");

    contactFormContainer.style.display = 'none';
    contactFormSuccessContainer.style.display = 'block';

    return 
}

function valueForId(elementId) {
    const element = document.getElementById(elementId);
    if (!element) {
        return;
    }

    return element.value;
}