import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var current_user_id = $("#current_user_id").val();

  consumer.subscriptions.create({channel: "NotificationChannel", admin_id: current_user_id }, {
    connected() {

    },
    disconnected() {

    },
    received(data) {
      $('#notifynumber').html(data.content.count)
      $('#notification').html(data.content.notification_html)
    }
  });
})
