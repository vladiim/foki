require 'mandrill'

module BaseMandrillMailer
  def self.send_mail(email, subject, template_name, attributes)
    mandrill = Mandrill::API.new(ENV['SMTP_PASSWORD'])
    body     = mandrill_template(mandrill, template_name, attributes)
    from     = merge_vars(attributes).select {|a| a[:name] == 'USERNAME'}[0].fetch(:content) {'Vlad from foki'}
    mandrill.messages.send(to: [email: email],
      from_email: 'foki.mail@gmail.com', from_name: from,
      subject: subject, html: body, content_type: 'text/html')
  end

  private

  def self.mandrill_template(mandrill, template_name, attributes)
    mandrill.templates.render(template_name, [], merge_vars(attributes))["html"]
  end

  def self.merge_vars(attributes)
    attributes.map do |key, value|
      { name: key, content: value }
    end
  end
end
