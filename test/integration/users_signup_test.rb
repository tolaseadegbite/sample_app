require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid user information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {  name: "",
                                          email: "foo@invalid",
                                          password: "foo",
                                          password_confirmation: "bar"}}
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {  name: "Foobar",
                                          email: "foobar@example.com",
                                          password: "foobar",
                                          password_confirmation: "foobar"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert.alert-success'
    assert is_logged_in?
  end
end
