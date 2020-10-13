class Admin::ConfirmationsController < Devise::ConfirmationsController
  authorize_resource User
end
