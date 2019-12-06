require "rails_helper"

RSpec.describe PropertiesController, type: :request do
  before(:example) do
    @user = create(:user)
    create(:user)
    log_in_as @user
  end

  describe "Index" do
    it "has Properties in the title" do
      get user_properties_path @user
      expect(response.body).to include("Properties | Warlock Mind")
    end
  end

  describe "New/Create" do
    it "has a link on the index page" do
      get user_properties_path @user
      expect(response.body).to include("Create a new property")
      expect(response.body).to include("/users/#{@user.id}/properties/new")
    end

    it "redirects to the new template" do
      get new_user_property_path @user
      expect(response).to render_template "properties/new"
    end

    it "accepts proper attributes on submit" do
      get new_user_property_path @user
      post user_properties_path(@user), params: { property: {
        name: "Light",
        notes: "This weapon is super light"
      } }
      expect(flash.empty?).to be false
      expect(response).to redirect_to user_properties_path
      follow_redirect!
      expect(response.body).to include("Light has been created")
      expect(response.body).to include("Light")
    end

    it "lists errors in the form if any" do
      get new_user_property_path @user
      post user_properties_path(@user), params: { property: {
        name: '',
        notes: ''
      } }
      expect(response.body).to include("Name can&#39;t be blank")
      expect(response.body).to include("Notes can&#39;t be blank")
    end
  end

  describe "Edit/Update" do
    it 'allows user to edit if admin or owner' do
      prop = create(:property, user_id: @user.id)
      get user_properties_path @user
      expect(response.body).to include("Update")
      get edit_property_path prop
      expect(response).to render_template("properties/edit")
      patch property_path(prop), params: { property: {
        name: "Updated Light",
        notes: "This is also Updated"
      }}
      expect(response).to redirect_to user_properties_path @user
      follow_redirect!
      expect(response.body).to include("Updated light")
    end

    it "changes title to Edit Property" do
      prop = create(:property, user_id: @user.id)
      get edit_property_path prop
      expect(response.body).to include("Edit Property | Warlock Mind")
    end
  end

  describe "Destroy" do
    it "only properties that belong to the user and admins can delele properties" do
      prop = create(:property, user_id: @user.id)
      get user_properties_path @user
      expect(response.body).to include("Delete")
      delete property_path prop
      expect(response).to redirect_to user_properties_path @user
      expect(response.body).to_not include(prop.name)
    end
  end
end
