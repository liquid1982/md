<?php

  date_default_timezone_set('Europe/Rome');
  session_start();

  define('ENV', (($_SERVER['HTTP_HOST'] == 'www.mandadream.com') ? 'production' : 'development'));

  require("../lib/class.phpmailer.php");
  require("../lib/formvalidator.php");

  $config = array(
    'production' => array(
      'booking_email_address' => 'mandadreamkenya@gmail.com',
      'use_smtp' => false,
      'smtp_host' => '',
      'smtp_port' => 25
    ),
    'development' => array(
      'booking_email_address' => 'vin.aci@gmail.com',
      'use_smtp' => true,
      'smtp_host' => 'smtp.cayenne.it',
      'smtp_port' => 25
    )
  );

  function check_fields() {
    $errors = array();

    $validator = new FormValidator();

    # $validator->addValidation("first_name","req", "");
    # $validator->addValidation("last_name","req", "");
    $validator->addValidation("email", "req", "");
    $validator->addValidation("email", "email", "");
    # $validator->addValidation("phone", "req", "");
    # $validator->addValidation("arrival_date", "req", "");
    # $validator->addValidation("nights", "req", "");
    # $validator->addValidation("people", "req", "");
    # $validator->addValidation("from_country", "req", "");

    if (!$validator->ValidateForm()) {
      foreach($validator->GetErrors() as $input_name => $input_error) {
        array_push($errors, $input_name);
      }
    }

    return $errors;
  }

  $errors = check_fields();

  if (count($errors) > 0) {
    $_SESSION['fields_with_errors'] = json_encode($errors);
    die(header('Location: form-booking-warning.php'));
  }

  $labels = array(
    'first_name'   => "Nome",
    'last_name'    => "Cognome",
    'email'        => "Email",
    'phone'        => "Telefono",
    'arrival_date' => "Data d'arrivo",
    'nights'       => "Numero notti",
    'people'       => "Numero persone",
    'from_country' => "Paese di provenienza",
    'notes'        => "Note",
    'newsletter'   => "Iscrizione alla Newsletter",
  );

  $provided_fields = array();

  foreach ($_REQUEST as $key => $value) {
    if ($value) { array_push($provided_fields, "<li><b>{$labels[$key]}</b>: {$value}</li>"); }
  }

  $details = "<ul>" . join('', $provided_fields) . "</ul>";

  $booking_mail = new PHPMailer();

  if ($config[ENV]['use_smtp']) {
    $booking_mail->IsSMTP();
    $booking_mail->Host = $config[ENV]['smtp_host'];
    $booking_mail->Port = $config[ENV]['smtp_port'];
  }

  $booking_mail->AddAddress($config[ENV]['booking_email_address']);
  $booking_mail->SetFrom("{$_REQUEST['first_name']} {$_REQUEST['last_name']}", $_REQUEST['email']);
  $booking_mail->IsHTML(true);

  $booking_mail->Subject = "[ Mandadream ] Nuova prenotazione";
  $booking_mail->Body    = <<<HTML
    <p>Una nuova prenotazione è stata effettuata mediante il sito web <b>Mandadream</b>.</p> <p>I dettagli sono di seguito riportati:</p>

    {$details}
    <p>Mail automatica generata da <a href="http://www.mandadream.it">Mandadream</a>.

HTML;

  $thankyou_mail = new PHPMailer();

  if ($config[ENV]['use_smtp']) {
    $thankyou_mail->IsSMTP();
    $thankyou_mail->Host = $config[ENV]['smtp_host'];
    $thankyou_mail->Port = $config[ENV]['smtp_port'];
  }

  $thankyou_mail->AddAddress($_REQUEST['email']);
  $thankyou_mail->SetFrom("Mandadream", $config[ENV]['booking_email_address']);
  $thankyou_mail->IsHTML(true);

  $thankyou_mail->Subject = "[ Mandadream ] Prenotazione effettuata con successo";
  $thankyou_mail->Body    = <<<HTML
    <p>Gentile {$_REQUEST['first_name']} {$_REQUEST['last_name']}, desideriamo ringraziarti per avereffettuato una prenotazione su Mandadream.</p> <p>Questi sono i dati da te inseriti:</p>

    {$details}
    <p>Grazie ancora dallo Staff di <a href="http://www.mandadream.it">Mandadream</a>.

HTML;

  if ($booking_mail->Send()) {
    $thankyou_mail->Send();
    header('Location: form-booking-success.html');
  } else {
    header('Location: form-booking-warning.php');
  }
