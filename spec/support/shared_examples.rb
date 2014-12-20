shared_examples "require_sign_in" do
  it "redirects to front page" do
    clear_current_user
    action
    expect(:response).to redirect_to new_user_session_path
  end
end
