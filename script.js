const imgBuffer = "";

const recognitionUrl = `https://hmcaptcha.com/Recognition?wait=1"`;

const payload = {
    Apikey: API_KEY,
    Type: "ALL_CAPTCHA_SLIDE",
    Image: imgBuffer.toString('base64') // Chuyển Buffer thành Base64
};

const response = await fetch(recognitionUrl, {
    method: "POST",
    headers: {
        "Content-Type": "application/json"
    },
    body: JSON.stringify(payload) // Chuyển object thành JSON
});

const responseBody = await response.json(); // Đọc phản hồi JSON từ server