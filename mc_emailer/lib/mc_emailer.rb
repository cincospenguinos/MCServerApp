require 'yaml'
require 'gmail'
require 'htmlentities'

class MCEmailer

  def initialize(config_file)
    raise RuntimeError, "Cannot fine #{config_file}" unless File.exist?(config_file)
    @@config = YAML.load_file(config_file)

    @html = HTMLEntities.new
  end

  # Notify that a request has been made
  def notify_request(username, email_address)
    # First to the guy who asked for it
    html = <<-HTML_TOKEN
        <h1>#{@html.encode username},</h1>

        <p>An access request for Andre's server has been submitted! Andre will be notified shortly.
        You will get another email from me when Andre has decided whether or not to let you in.</p>
        <br/>
        <h3>- Andre's MC Admin Bot</h3>
        <p style="font-size: xx-small;">I am a bot! I will not respond to any emails you send me! If you would
        like to see Andre's code, check it out on Github <a href="https://github.com/cincospenguinos/MCServerApp">here</a>.</p>
    HTML_TOKEN

    send_email("Access Request for #{@html.encode username}", email_address, html)

    # Now to me
    body = <<-BODY_TOKEN
        <h1>Andre,</h1>

        <p>#{@html.encode username} has requested access to your server. His/her email address
        is #{@html.encode email_address}. Go ahead and email me back with either "YES #{@html.encode  username}"
        or "NO #{@html.encode  username}" to handle this request.</p>

        <h3>- Your MC Admin Bot</h3>
    BODY_TOKEN

    send_email("Access Request for #{@html.encode  username}", @@config[:admin_email_address], body)
  end

  # Notify that someone has been accepted
  def notify_accepted(username, email_address)
    html = <<-HTML_TOKEN
      <h1>#{@html.encode username},</h1>

      <p>You have been accepted to join Andre's server! Go ahead and connect using andreminecraft.duckdns.org.
      Let Andre know if you have any questions.</p>
      <h3>- Andre's MC Admin Bot</h3>
      <p style="font-size: xx-small;">I am a bot! I will not respond to any emails you send me! If you would
      like to see Andre's code, check it out on Github <a href="https://github.com/cincospenguinos/MCServerApp">here</a>.</p>
    HTML_TOKEN

    send_email("Congrats #{@html.encode username}!", email_address, html)
  end

  # Notify that someone has been rejected
  def notify_rejected(username, email_address)
    html = <<-HTML_TOKEN
      <h1>#{@html.encode username},</h1>

      <p>I regret to inform you that you have been denied access to Andre's server. This may change in the future; ask
      Andre for details.</p>
      <h3>- Andre's MC Admin Bot</h3>
      <p style="font-size: xx-small;">I am a bot! I will not respond to any emails you send me! If you would
      like to see Andre's code, check it out on Github <a href="https://github.com/cincospenguinos/MCServerApp">here</a>.</p>
    HTML_TOKEN

    send_email("Access for #{@html.encode username}", email_address, html)
  end

  private

  def send_email(subject, recipient, html)
    Gmail.connect!(@@config[:email_address], @@config[:password]) do |gmail|
      gmail.deliver! do
        to recipient
        subject subject
        html_part do
          content_type 'text/html; charset=UTF-8'
          body html
        end
      end
    end
  end
end