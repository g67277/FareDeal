function ViewModel() {
    var self = this;

    var tokenKey = 'accessToken';

    self.result = ko.observable();
    self.user = ko.observable();

    self.registerEmail = ko.observable();
    self.registerPassword = ko.observable();
    self.registerPassword2 = ko.observable();
    self.registerUserName = ko.observable();

    self.loginEmail = ko.observable();
    self.loginPassword = ko.observable();

    self.resetPasswordEmail = ko.observable();


    function showError(jqXHR) {
        self.result(jqXHR.status + ': ' + jqXHR.statusText);
    }

    self.callApi = function () {
        self.result('');

        var token = sessionStorage.getItem(tokenKey);
        var headers = {};
        if (token) {
            headers.Authorization = 'Bearer ' + token;
        }

        $.ajax({
            type: 'GET',
            url: '/api/values',
            headers: headers
        }).done(function (data) {
            self.result(data);
        }).fail(showError);
    }

    self.register = function () {
        self.result('');

        var data = {
            UserName: self.registerUserName(),
            Email: self.registerEmail(),
            Password: self.registerPassword(),
            ConfirmPassword: self.registerPassword2(),
            IsBusiness: true
        };

        $.ajax({
            type: 'POST',
            url: '/api/Account/Register',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(data)
        }).done(function (data) {
            self.result("Done!");
        }).fail(showError);
    }

    self.login = function () {
        self.result('');

        var loginData = {
            grant_type: 'password',
            username: self.loginEmail(),
            password: self.loginPassword()
        };

        $.ajax({
            type: 'POST',
            url: '/Token',
            data: loginData
        }).done(function (data) {
            self.user(data.userName);
            // Cache the access token in session storage.
            sessionStorage.setItem(tokenKey, data.access_token);
        }).fail(showError);
    }

    self.logout = function () {
        self.user('');
        sessionStorage.removeItem(tokenKey)
    }


    self.forgotpassword = function () {
        self.result('');

        var data = {
            email: self.resetPasswordEmail()
        };

        $.ajax({
            type: 'GET',
            url: '/api/Account/ForgotPassword?email=' + self.resetPasswordEmail(),
            contentType: 'application/text; charset=utf-8'
        }).done(function (data) {
            alert("Check your email");
            //self.result("Done!");
        }).fail(showError);
    }

    $('#btn').click(function () {

        var token = sessionStorage.getItem(tokenKey);
        var headers = {};
        if (token) {
            headers.Authorization = 'Bearer ' + token;
        }

        var name = "Restaurent" + Math.random();

        var data = {
            FirstName: 'Hemal',
            LastName: 'Patel',
            StreetName: 'Test St',
            City: 'Washington',
            State: 'DC',
            ZipCode: '22055',
            PhoneNumber: '2222222222',
            PriceTier: 1,
            WeekdaysHours: '10AM-10PM',
            WeekEndHours: '10AM-12AM',
            RestaurantName: name,
            Lat: "38.907192",
            Lang: "-77.036871",
            CategoryName:"Burger"
        };

        $.ajax({
            type: 'POST',
            url: '/api/Venue',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(data),
            headers: headers
        }).done(function (data) {
            self.result("Done!");
        }).fail(showError);
    });


    $('#btn_password_reset').click(function () {
        var headers = {};
        var token = $('#token').val();
        var id = $('#id').val();
        var p1 = $('#resetPassword1').val();
        var p2 = $('#resetPassword2').val()
        if (p1 != p2) {
            alert("New Password and Confirm password do not match, try again!");
            return;
        }
        var resetData = {
            NewResetPassword: $('#resetPassword1').val(),
            ConfirmResetPassword: $('#resetPassword2').val(),
            id: id,
            code: token
        };

        $.ajax({
            type: 'POST',
            url: '/api/Account/ResetPassword',
            data: resetData
        }).done(function (data) {
            alert("Password has been changed!");
            //self.user(data.userName);
            // Cache the access token in session storage.
            //sessionStorage.setItem(tokenKey, data.access_token);
        }).error(function (jqXHR) {
            alert("There was an error resetting password! Your reset email link is expired.");
        });
    });
}

var app = new ViewModel();
ko.applyBindings(app);