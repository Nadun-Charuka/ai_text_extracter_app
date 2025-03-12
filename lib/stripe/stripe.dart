//stripe init method
import 'package:ai_text_extracter_app/stripe/stripe_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> inti({
  required String name,
  required String email,
}) async {
  // create new customer
  Map<String, dynamic>? customer = await createCustomer(
    email: email,
    name: name,
  );
  if (customer == null || customer["id"] == null) {
    throw Exception("Faild to create a customer");
  }

  //create a payment intent
  Map<String, dynamic>? paymentIntent = await createPaymentIntent(
    customerId: customer["id"],
  );
  if (paymentIntent == null || paymentIntent["client_secret"] == null) {
    throw Exception('Failed to create payment intent');
  }

  //create a creadit card
  await createCreaditCard(
    customerId: customer["id"],
    clientSecret: paymentIntent["client_secret"],
  );

  //retrieve customer payement methods
  Map<String, dynamic>? customerPaymentMethods =
      await getCustomerPaymentMethods(customerId: customer["id"]);
  if (customerPaymentMethods == null ||
      customerPaymentMethods['data'].isEmpty) {
    throw Exception('Failed to get customer payment methods.');
  }

  //create subscription
  Map<String, dynamic>? subscription = await createSubscription(
      customerId: customer['id'],
      paymentId: customerPaymentMethods['data'][0]['id']);

  if (subscription == null || subscription['id'] == null) {
    throw Exception('Failed to create subscription.');
  }
}

//create customer
Future<Map<String, dynamic>?> createCustomer({
  required String email,
  required String name,
}) async {
  final customerCreationResponse = await stripeApiService(
    requestMethode: ApiServiceMethodeType.post,
    endPoint: "customers",
    requestBody: {
      "name": name,
      "email": email,
      "description": "Text extractor pro plan",
    },
  );
  return customerCreationResponse;
}

//create payment intent
Future<Map<String, dynamic>?> createPaymentIntent(
    {required String customerId}) async {
  final paymentIntentCreationResponse = await stripeApiService(
    requestMethode: ApiServiceMethodeType.post,
    endPoint: "setup_intents",
    requestBody: {
      'customer': customerId,
      'automatic_payment_methods[enabled]': true,
    },
  );

  return paymentIntentCreationResponse;
}

//create a creadit card
Future<void> createCreaditCard({
  required String customerId,
  required String clientSecret,
}) async {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      primaryButtonLabel: 'Subscribe \$4.99 monthly',
      style: ThemeMode.light,
      merchantDisplayName: 'Text Extractor Pro Plan',
      customerId: customerId,
      setupIntentClientSecret: clientSecret,
    ),
  );
  await Stripe.instance.presentPaymentSheet();
}

//get customer payment method
Future<Map<String, dynamic>?> getCustomerPaymentMethods({
  required String customerId,
}) async {
  final customerPaymentMethodsResponse = await stripeApiService(
    requestMethode: ApiServiceMethodeType.get,
    endPoint: "customers/$customerId/payment_method",
  );
  return customerPaymentMethodsResponse;
}

//create subsription
Future<Map<String, dynamic>?> createSubscription({
  required String customerId,
  required String paymentId,
}) async {
  final subscriptionCreationResponse = await stripeApiService(
      requestMethode: ApiServiceMethodeType.post,
      endPoint: "subscriptions",
      requestBody: {
        'customer': customerId,
        'default_payment_method': paymentId,
        'items[0][price]': "price_1R1sjrE15SVEt9jixC7oSNqT",
      });
  return subscriptionCreationResponse;
}
