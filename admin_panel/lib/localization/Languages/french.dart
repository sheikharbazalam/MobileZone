//Add French Language Translations
import '../../utils/constants/text_strings.dart';

class French {
  static Map<String, String> get language => {
    // Admin Default Credentials
    TTexts.adminEmail: "support@codingwitht.com",
    TTexts.adminPassword: "Admin@123",
    TTexts.english: "Anglais",
    TTexts.french: "Français",

    // Authentication Forms
    TTexts.firstName: "Prénom",
    TTexts.lastName: "Nom",
    TTexts.name: "Nom",
    TTexts.email: "E-Mail",
    TTexts.password: "Mot de passe",
    TTexts.newPassword: "Nouveau mot de passe",
    TTexts.username: "Nom d'utilisateur",
    TTexts.phoneNo: "Numéro de téléphone",
    TTexts.rememberMe: "Se souvenir de moi",
    TTexts.forgetPassword: "Mot de passe oublié ?",
    TTexts.signIn: "Se connecter",
    TTexts.createAccount: "Créer un compte",
    TTexts.orSignInWith: "ou se connecter avec",
    TTexts.orSignUpWith: "ou s'inscrire avec",
    TTexts.iAgreeTo: "Je suis d'accord avec",
    TTexts.privacyPolicy: "Politique de confidentialité",
    TTexts.termsOfUse: "Conditions d'utilisation",
    TTexts.verificationCode: "Code de vérification",
    TTexts.resendEmail: "Renvoyer l'e-mail",
    TTexts.resendEmailIn: "Renvoyernvoyer l'e-mail d l'e-mail dans",
    TTexts.redirect: "Redirect",

    // Authentication Headings
    TTexts.loginTitle: "Bon retour,",
    TTexts.loginSubTitle:
        "Découvrez des choix illimités et une commodité inégalée.",
    TTexts.signupTitle: "Créons votre compte",
    TTexts.forgetPasswordTitle: "Mot de passe oublié",
    TTexts.forgetPasswordSubTitle:
        "Ne vous inquiétez pas, parfois les gens peuvent oublier aussi, entrez votre e-mail et nous vous enverrons un lien de réinitialisation du mot de passe.",
    TTexts.changeYourPasswordTitle:
        "E-mail de réinitialisation du mot de passe envoyé",
    TTexts.changeYourPasswordSubTitle:
        "La sécurité de votre compte est notre priorité ! Nous vous avons envoyé un lien sécurisé pour changer votre mot de passe en toute sécurité et protéger votre compte.",
    TTexts.confirmEmail: "Vérifiez votre adresse e-mail !",
    TTexts.confirmEmailSubTitle:
        "Félicitations ! Votre compte vous attend : Vérifiez votre e-mail pour commencer à magasiner et découvrir un monde d'offres inégalées et d'offres personnalisées.",
    TTexts.emailNotReceivedMessage:
        "Vous n'avez pas reçu l'e-mail ? Vérifiez vos spams ou renvoyez-le.",
    TTexts.yourAccountCreatedTitle: "Votre compte a été créé avec succès !",
    TTexts.yourAccountCreatedSubTitle:
        "Bienvenue dans votre destination shopping ultime : Votre compte est créé, profitez du plaisir d'un shopping en ligne fluide !",

    // Product
    TTexts.popularProducts: "Produits populaires",

    // Home
    TTexts.homeAppbarTitle: "Bonne journée pour faire des achats",
    TTexts.homeAppbarSubTitle: "Taimoor Sikander",
    TTexts.searchAnything: "Rechercher n'importe quoi...",

    // -- Firebase
    TTexts.createNewIndex: "Créer un nouvel index",
    TTexts.queryRequiresIndex:
        "La requête nécessite un index. Créez cet index et réessayez.",
    TTexts.errorVerifyingFileExistence:
        "Erreur lors de la vérification de l'existence du fichier.",
    TTexts.somethingWentWrong:
        "Quelque chose s'est mal passé. Veuillez réessayer",
    TTexts.somethingWentWrongDetail: "Quelque chose s'est mal passé",
    TTexts.invalidImagePath: 'Chemin d\'image invalide: ',
    TTexts.fileStillExistsAfterDeletion:
        'Le fichier existe toujours après la tentative de suppression: ',
    TTexts.supabaseStorageError: 'Erreur de stockage Supabase ',
    TTexts.firestoreError: 'Erreur Firestore ',

    // -- Storage
    TTexts.errorLoadingImageData:
        'Erreur lors du chargement des données de l\'image: ',
    TTexts.firebaseException: 'Exception Firebase: ',
    TTexts.networkError: 'Erreur réseau: ',
    TTexts.platformException: 'Exception de la plateforme: ',
    TTexts.somethingWentWrongPleaseTryAgain:
        'Quelque chose s\'est mal passé! Veuillez réessayer.',

    // Page Not Found
    TTexts.pageNotFoundTitle:
        "Oops! Vous vous êtes aventuré dans l'abîme d'Internet!",
    TTexts.pageNotFoundSubTitle:
        "On dirait que vous avez découvert le Triangle des Bermudes de notre application. Ne vous inquiétez pas, nous ne vous laisserons pas perdu pour toujours. Cliquez sur le bouton ci-dessous pour retourner en toute sécurité!",

    // Exception Messages
    TTexts.unexpectedError:
        "Une erreur inattendue est survenue. Veuillez réessayer.",
    TTexts.emailAlreadyInUse:
        "L'adresse e-mail est déjà enregistrée. Veuillez utiliser une autre adresse e-mail.",
    TTexts.invalidEmail:
        "L'adresse e-mail fournie est invalide. Veuillez entrer une adresse e-mail valide.",
    TTexts.weakPassword:
        "Le mot de passe est trop faible. Veuillez choisir un mot de passe plus fort.",
    TTexts.userDisabled:
        "Ce compte utilisateur a été désactivé. Veuillez contacter le support pour obtenir de l'aide.",
    TTexts.userNotFound:
        "Identifiants de connexion invalides. Utilisateur non trouvé.",
    TTexts.userDoesNotExist: "L'utilisateur n'existe pas!",
    TTexts.productDoesNotExist: "Le produit n'existe pas!",
    TTexts.productNotFoundReviewDeleted:
        "Produit non trouvé; avis supprimé. Saut des mises à jour du produit.",
    TTexts.errorUploadingAudioFile:
        "Erreur lors du téléversement du fichier audio: ",
    TTexts.errorFetchingAudioFile:
        "Erreur lors de la récupération du fichier audio: ",
    TTexts.wrongPassword:
        "Mot de passe incorrect. Veuillez vérifier votre mot de passe et réessayer.",
    TTexts.invalidLoginCredentials:
        "Identifiants de connexion invalides. Veuillez revérifier vos informations.",
    TTexts.tooManyRequests: "Trop de demandes. Veuillez réessayer plus tard.",
    TTexts.invalidArgument:
        "Argument invalide fourni à la méthode d'authentification.",
    TTexts.invalidPassword: "Mot de passe incorrect. Veuillez réessayer.",
    TTexts.invalidPhoneNumber: "Le numéro de téléphone fourni est invalide.",
    TTexts.operationNotAllowed:
        "Le fournisseur de connexion est désactivé pour votre projet Firebase.",
    TTexts.sessionCookieExpired:
        "Le cookie de session Firebase a expiré. Veuillez vous reconnecter.",
    TTexts.uidAlreadyExists:
        "L'ID utilisateur fourni est déjà utilisé par un autre utilisateur.",
    TTexts.signInFailed: "Échec de la connexion. Veuillez réessayer.",
    TTexts.networkRequestFailed:
        "La requête réseau a échoué. Veuillez vérifier votre connexion Internet.",
    TTexts.internalError: "Erreur interne. Veuillez réessayer plus tard.",
    TTexts.invalidVerificationCode:
        "Code de vérification invalide. Veuillez entrer un code valide.",
    TTexts.invalidVerificationId:
        "ID de vérification invalide. Veuillez demander un nouveau code de vérification.",
    TTexts.quotaExceeded: "Quota dépassé. Veuillez réessayer plus tard.",
    TTexts.unknownFirebaseError:
        "Une erreur Firebase inconnue est survenue. Veuillez réessayer.",
    TTexts.invalidCustomToken:
        "Le format du jeton personnalisé est incorrect. Veuillez vérifier votre jeton personnalisé.",
    TTexts.customTokenMismatch:
        "Le jeton personnalisé correspond à une audience différente.",
    TTexts.providerAlreadyLinked:
        "Le compte est déjà lié à un autre fournisseur.",
    TTexts.invalidCredential: "La croyance fournie est malformée ou a expiré.",
    TTexts.captchaCheckFailed:
        "La réponse reCAPTCHA est invalide. Veuillez réessayer.",
    TTexts.appNotAuthorized:
        "L'application n'est pas autorisée à utiliser l'authentification Firebase avec la clé API fournie.",
    TTexts.keychainError:
        "Une erreur de trousseau est survenue. Veuillez vérifier le trousseau et réessayer.",
    TTexts.invalidAppCredential:
        "La croyance de l'application est invalide. Veuillez fournir une croyance d'application valide.",
    TTexts.userMismatch:
        "Les croyances fournies ne correspondent pas à l'utilisateur précédemment connecté.",
    TTexts.requiresRecentLogin:
        "Cette opération est sensible et nécessite une authentification récente. Veuillez vous reconnecter.",
    TTexts.accountExistsWithDifferentCredential:
        "Un compte existe déjà avec le même e-mail mais des croyances de connexion différentes.",
    TTexts.missingIframeStart:
        "Le modèle d'e-mail ne contient pas la balise de début d'iframe.",
    TTexts.missingIframeEnd:
        "Le modèle d'e-mail ne contient pas la balise de fin d'iframe.",
    TTexts.missingIframeSrc:
        "Le modèle d'e-mail ne contient pas l'attribut src de l'iframe.",
    TTexts.authDomainConfigRequired:
        "La configuration authDomain est requise pour le lien de vérification du code d'action.",
    TTexts.missingAppCredential:
        "La croyance de l'application est manquante. Veuillez fournir des croyances d'application valides.",
    TTexts.webStorageUnsupported:
        "Le stockage Web n'est pas pris en charge ou est désactivé.",
    TTexts.appDeleted: "Cette instance de FirebaseApp a été supprimée.",
    TTexts.userTokenMismatch:
        "Le jeton de l'utilisateur fourni ne correspond pas à l'ID de l'utilisateur authentifié.",
    TTexts.invalidMessagePayload:
        "La charge utile du message de vérification du modèle d'e-mail est invalide.",
    TTexts.invalidSender:
        "L'expéditeur du modèle d'e-mail est invalide. Veuillez vérifier l'e-mail de l'expéditeur.",
    TTexts.invalidRecipientEmail:
        "L'adresse e-mail du destinataire est invalide. Veuillez fournir une adresse e-mail de destinataire valide.",
    TTexts.missingActionCode:
        "Le code d'action est manquant. Veuillez fournir un code d'action valide.",
    TTexts.userTokenExpired:
        "Le jeton de l'utilisateur a expiré et une authentification est requise. Veuillez vous reconnecter.",
    TTexts.expiredActionCode:
        "Le code d'action a expiré. Veuillez demander un nouveau code d'action.",
    TTexts.invalidActionCode:
        "Le code d'action est invalide. Veuillez vérifier le code et réessayer.",
    TTexts.credentialAlreadyInUse:
        "Cette croyance est déjà associée à un autre compte utilisateur.",
    TTexts.emailAlreadyExists:
        "L'adresse e-mail existe déjà. Veuillez utiliser une autre adresse e-mail.",
    TTexts.userTokenRevoked:
        "Le jeton de l'utilisateur a été révoqué. Veuillez vous reconnecter.",
    TTexts.invalidCordovaConfiguration:
        "La configuration Cordova fournie est invalide.",
    TTexts.userTokenExpiredAuth:
        "Le jeton de l'utilisateur a expiré et une authentification est requise. Veuillez vous reconnecter.",
    TTexts.emailOrPasswordIncorrect:
        "L'e-mail ou le mot de passe est incorrect.",
    TTexts.unexpectedFirebaseError:
        "Une erreur Firebase inattendue est survenue. Veuillez réessayer.",
    TTexts.unexpectedFormatError:
        "Une erreur de format inattendue est survenue. Veuillez vérifier votre saisie.",
    TTexts.invalidEmailFormat:
        "Le format de l'adresse e-mail est invalide. Veuillez entrer une adresse e-mail valide.",
    TTexts.invalidPhoneNumberFormat:
        "Le format du numéro de téléphone fourni est invalide. Veuillez entrer un numéro valide.",
    TTexts.invalidDateFormat:
        "Le format de la date est invalide. Veuillez entrer une date valide.",
    TTexts.invalidUrlFormat:
        "Le format de l'URL est invalide. Veuillez entrer une URL valide.",
    TTexts.invalidCreditCardFormat:
        "Le format de la carte de crédit est invalide. Veuillez entrer un numéro de carte de crédit valide.",
    TTexts.invalidNumericFormat:
        "L'entrée doit être un format numérique valide.",
    TTexts.unexpectedPlatformError:
        "Une erreur de plate-forme inattendue est survenue. Veuillez réessayer.",
    TTexts.processingRequest: "Traitement de votre demande...",
    TTexts.loggingYouIn: "Connexion en cours...",
    TTexts.registeringAdminAccount:
        "Enregistrement du compte administrateur...",
    TTexts.emailSent: "E-mail envoyé",
    TTexts.emailLinkSentToResetPassword:
        "Lien par e-mail envoyé pour réinitialiser votre mot de passe",
    TTexts.ohSnap: "Oh non!",
    TTexts.dashboardTypes: "Types de tableau de bord",
    TTexts.dashboard: "Tableau de bord",
    TTexts.salesTotal: "Total des ventes",
    TTexts.averageOrderValue: "Valeur moyenne des commandes",
    TTexts.totalOrders: "Total des commandes",
    TTexts.soldProducts: "Produits vendus",
    TTexts.recentOrders: "Commandes récentes",
    TTexts.ordersStatus: "État des commandes",
    TTexts.weeklySales: "Ventes hebdomadaires",
    TTexts.pending: "En attente",
    TTexts.processing: "En cours de traitement",
    TTexts.shipped: "Expédié",
    TTexts.delivered: "Livré",
    TTexts.cancelled: "Annulé",
    TTexts.returned: "Retourné",
    TTexts.refunded: "Remboursé",
    TTexts.orderId: "ID de commande",
    TTexts.date: "Date",
    TTexts.items: "Articles",
    TTexts.status: "Statut",
    TTexts.amount: "Montant",
    TTexts.comparedTo: "Comparé à",
    TTexts.mediaManager: "Gestionnaire de médias",
    TTexts.media: "Média",
    TTexts.uploadImages: "Télécharger des images",
    TTexts.selectImages: "Sélectionner des images",
    TTexts.dragAndDropImagesHere: "Glissez et déposez les images ici",
    TTexts.selectStorageType: "Sélectionner le type de stockage",
    TTexts.chooseStorage:
        "Choisissez le stockage dans lequel vous souhaitez télécharger vos images.",
    TTexts.selectFolder: "Sélectionner un dossier",
    TTexts.chooseFolder:
        "Choisissez le dossier dans lequel vous souhaitez télécharger vos images.",
    TTexts.add: "Ajouter",
    TTexts.deleteImage: "Supprimer l'image",
    TTexts.deleteImageConfirm:
        "Êtes-vous sûr de vouloir supprimer cette image?",
    TTexts.uploadingImages: "Téléchargement d'images",
    TTexts.uploadingImagesSitTight:
        "Attendez, vos images sont en cours de téléchargement...",
    TTexts.itsEmptyHere: "C'est vide ici...",
    TTexts.loading: "Chargement...",
    TTexts.loadMore: "Charger plus",
    TTexts.folderNotFound: "Dossier non trouvé",
    TTexts.pleaseSelectFolder:
        "Veuillez sélectionner le dossier pour télécharger les images",
    TTexts.areYouSureUploadImages:
        "Êtes-vous sûr de vouloir télécharger toutes les images dans",
    TTexts.areYouSureDeleteImage:
        "Êtes-vous sûr de vouloir supprimer cette image?",
    TTexts.imageDeleted: "Image supprimée",
    TTexts.imageDeletedSuccess:
        "Image supprimée avec succès de votre stockage cloud",
    TTexts.errorUploadingImages: "Erreur lors du téléchargement des images",
    TTexts.imageName: "Nom de l'image:",
    TTexts.imageSize: "Taille de l'image:",
    TTexts.imageType: "Type d'image:",
    TTexts.dateCreated: "Date de création:",
    TTexts.imageUrl: "URL de l'image:",
    TTexts.urlCopied: "URL copiée",
    TTexts.chooseFolderToUpload: "Sélectionnez le dossier souhaité",
    TTexts.noImagesFound: "Aucune image trouvée dans ce dossier.",
    TTexts.youAreViewingAllImages: "Vous visualisez toutes les images de",
    TTexts.loadingImages: "Chargement des images...",
    TTexts.loadMoreImages: "Charger plus d'images",
    TTexts.loadingMoreImages: "Chargement de plus d'images...",
    TTexts.chooseStorageToUpload:
        "Choisissez le stockage pour télécharger vos images.",
    TTexts.support: "Support",
    TTexts.chats: "Discussions",
    TTexts.noChatsAvailable: "Aucune discussion disponible",
    TTexts.messages: "Messages",
    TTexts.allMessages: "Tous les messages",
    TTexts.typeAMessage: "Taper un message...",
    TTexts.noRecentMessage: "Aucun message récent",
    TTexts.audioMessage: "Message audio",
    TTexts.image: "Image",
    TTexts.gallery: "Galerie",
    TTexts.camera: "Appareil photo",
    TTexts.permissionError: "Erreur de permission",
    TTexts.failedToGetMicrophonePermissions:
        "Échec de l'obtention des autorisations du microphone.",
    TTexts.recordingError: "Erreur d'enregistrement",
    TTexts.failedToStartRecording: "Échec du démarrage de l'enregistrement.",
    TTexts.pauseError: "Erreur de pause",
    TTexts.failedToPauseRecording:
        "Échec de la mise en pause de l'enregistrement.",
    TTexts.stopError: "Erreur d'arrêt",
    TTexts.failedToStopRecording: "Échec de l'arrêt de l'enregistrement.",
    TTexts.cancelError: "Erreur d'annulation",
    TTexts.failedToCancelRecording:
        "Échec de l'annulation de l'enregistrement.",
    TTexts.unableToFetchMessages: "Impossible de récupérer les messages",
    TTexts.failedToSendMessagePleaseTryAgain:
        "Impossible d'envoyer le message. Veuillez réessayer.",
    TTexts.noImageSelected: "Aucune image sélectionnée",
    TTexts.pleaseSelectAnImageToSend:
        "Veuillez sélectionner une image à envoyer.",
    TTexts.unableToSendImage:
        "Impossible d'envoyer l'image. Veuillez réessayer.",
    TTexts.retailerDetails: "Détails du détaillant",
    TTexts.shopDetails: "Détails de la boutique",
    TTexts.uploadShopImage: "Télécharger l'image de la boutique",
    TTexts.shopName: "Nom de la boutique",
    TTexts.shopRegistrationNumber: "Numéro d'enregistrement de la boutique",
    TTexts.shopTaxID: "ID fiscal de la boutique",
    TTexts.shopAddress: "Adresse de la boutique",
    TTexts.featured: "En vedette",
    TTexts.isActive: "Est actif",
    TTexts.create: "Créer",
    TTexts.update: "Mettre à jour",
    TTexts.allRetailers: "Tous les détaillants",
    TTexts.retailer: "Détaillant",
    TTexts.shop: "Boutique",
    TTexts.verification: "Vérification",
    TTexts.ids: "ID",
    TTexts.action: "Action",
    TTexts.taxId: "ID fiscal",
    TTexts.createNewRetailer: "Créer un nouveau détaillant",
    TTexts.createRetailer: "Créer un détaillant",
    TTexts.editRetailer: "Modifier le détaillant",
    TTexts.createNewAttribute: "Créer un nouvel attribut",
    TTexts.congratulations: "Félicitations",
    TTexts.newRecordAdded: "Nouvel enregistrement ajouté",
    TTexts.recordUpdated: "Votre enregistrement a été mis à jour.",
    TTexts.removeAttributeTitle: "Supprimer l'attribut",
    TTexts.removeAttributeContent:
        "Êtes-vous sûr de vouloir supprimer cet attribut? Cette action peut réinitialiser les variations de produit.",
    TTexts.salePriceCannotBeGreater:
        "Le prix de vente ne peut pas être supérieur au prix.",
    TTexts.noVariationsFound:
        "Aucune variation trouvée. Créez-en ou modifiez le type de produit.",
    TTexts.variationDataNotAccurate:
        "Les données de variation ne sont pas exactes. Veuillez revérifier les variations",
    TTexts.variationDiscountedPriceGreater:
        "Le prix réduit de la variation ne peut pas être égal ou supérieur au prix. Corrigez cela et soumettez à nouveau.",
    TTexts.selectProductThumbnail: "Sélectionner l'image miniature du produit",
    TTexts.updatingProduct: "Mise à jour du produit",
    TTexts.sitTightProductUploading:
        "Attendez, votre produit est en cours de téléchargement...",
    TTexts.goToProducts: "Aller aux produits",
    TTexts.yourProductUpdatedSuccessfully:
        "Votre produit a été mis à jour avec succès.",
    TTexts.thumbnailImage: "Image miniature",
    TTexts.additionalImages: "Images supplémentaires",
    TTexts.productDataAttributesVariations:
        "Données produit, attributs et variations",
    TTexts.productCategories: "Catégories de produits",
    TTexts.yourProductCreatedSuccessfully:
        "Votre produit a été créé avec succès",
    TTexts.removeVariationsTitle: "Supprimer les variations",
    TTexts.generate: "Générer",
    TTexts.generateVariationsTitle: "Générer des variations",
    TTexts.generateVariationsContent:
        "Une fois les variations créées, les attributs ne peuvent plus être ajoutés. Pour ajouter d'autres variations, supprimez un attribut existant.",
    TTexts.reviewCreated: "Avis créé",
    TTexts.productAttributes: "Attributs du produit",
    TTexts.allAttributes: "Tous les attributs",
    TTexts.noAttributesAdded: "Aucun attribut n'a été ajouté pour ce produit",
    TTexts.noAttributesFound: "Aucun attribut trouvé!",
    TTexts.addAttributesPrompt:
        "Voulez-vous ajouter des attributs? Cliquez ici.",
    TTexts.allAttributesAdded: "Tous les attributs ajoutés.",
    TTexts.selectAttribute: "Sélectionner l'attribut",
    TTexts.productBrand: "Marque du produit",
    TTexts.selectBrand: "Sélectionner la marque",
    TTexts.selectDesiredBrand: "Sélectionnez une marque souhaitée",
    TTexts.noBrandsFound: "Aucune marque trouvée...",
    TTexts.thereAreNoCategoriesSelected: "Aucune catégorie n'est sélectionnée",
    TTexts.addCategories: "Ajouter des catégories",
    TTexts.chooseCategories: "Choisir des catégories",
    TTexts.close: "Fermer",
    TTexts.saveChanges: "Enregistrer les modifications",
    TTexts.discard: "Annuler",

    // -- Order
    TTexts.billingAddress: "Adresse de facturation",
    TTexts.billingAddressSameAsShipping:
        "L'adresse de facturation est la même que l'adresse de livraison.",
    TTexts.orderItems: "Articles de la commande",
    TTexts.price: "Prix",
    TTexts.qty: "Qté",
    TTexts.priceLabel: "Prix: ",
    TTexts.quantityLabel: "Quantité: ",
    TTexts.subtotal: "Sous-total",
    TTexts.couponDiscount: "Réduction du coupon",
    TTexts.pointBasedDiscount: "Réduction basée sur les points",
    TTexts.pointsUsedLabel: "Points utilisés: ",
    TTexts.shipping: "Livraison",
    TTexts.tax: "Taxe",
    TTexts.total: "Total",
    TTexts.orderInformation: "Informations sur la commande",
    TTexts.orderTransaction: "Transaction de la commande",
    TTexts.paymentMethodId: "ID du mode de paiement",
    TTexts.paymentIntentId: "ID de l'intention de paiement",
    TTexts.customer: "Client",
    TTexts.shippingAddress: "Adresse de livraison",
    TTexts.updateStatus: "Mettre à jour le statut",
    TTexts.orderActivity: "Activité de la commande",
    TTexts.activityPerformedBy: "Activité effectuée par {by}, le {on}.",
    TTexts.ser: "Sér",
    TTexts.orderStatus: "État de la commande",
    TTexts.paymentStatus: "État du paiement",
    TTexts.allOrders: "Toutes les commandes",
    TTexts.orders: "Commandes",
    TTexts.orderDetails: "Détails de la commande",
    TTexts.orderDetailsDynamic: "Détails de la commande #{id}",
    TTexts.paymentStatusIs: "L'état du paiement est {status}. ",
    TTexts.orderPlacedOn: "Commande passée le {date}.",
    TTexts.CWTADMIN50OFF: "CWTADMIN50OFF",

    // Product Management UI
    TTexts.createProduct: "Créer un produit",
    TTexts.updateProduct: "Mettre à jour le produit",
    TTexts.allProducts: "Tous les produits",
    TTexts.productConfiguration: "Configuration et gestion des produits",
    TTexts.chooseAttributeValues: "Choisir les valeurs d'attribut",
    TTexts.addAttribute: "Ajouter un attribut",
    TTexts.productTags: "Étiquettes de produit",
    TTexts.productTagsNote:
        "Remarque: Nous utiliserons ces étiquettes pour rechercher le produit, alors ajoutez soigneusement toutes les étiquettes possibles. \nUtilisez des étiquettes en minuscules.",
    TTexts.tags: "Étiquettes",
    TTexts.addCommaSeparatedTags:
        "Ajouter des étiquettes séparées par des virgules (,)",
    TTexts.productThumbnail: "Miniature du produit",
    TTexts.addThumbnail: "Ajouter une miniature",
    TTexts.basicInformation: "Informations de base",
    TTexts.productTitle: "Titre du produit",
    TTexts.description: "Description",
    TTexts.addDescription: "Ajouter une description de cette variation...",
    TTexts.productVisibility: "Visibilité du produit",
    TTexts.publish: "Publier",
    TTexts.draft: "Brouillon",
    TTexts.createNewProduct: "Créer un nouveau produit",
    TTexts.na: "N/A",
    TTexts.published: "Publié",
    TTexts.productType: "Type de produit",
    TTexts.single: "Unique",
    TTexts.variable: "Variable",
    TTexts.stock: "Stock",
    TTexts.addStockHint: "Ajouter du stock, seuls les chiffres sont autorisés",
    TTexts.sku: "SKU",
    TTexts.addSkuHint: "Ajouter une unité de gestion des stocks",
    TTexts.priceHint: "Prix avec jusqu'à 2 décimales",
    TTexts.discountedPrice: "Prix réduit",
    'productVariations': 'Variations du produit',
    'removeVariations': 'Supprimer les variations',
    'addVariationDescriptionHint':
        'Ajouter une description de cette variation...',
    'noVariationsAdded': 'Aucune variation n\'a été ajoutée pour ce produit',
    TTexts.product: 'Produit',
    TTexts.brand: 'Marque',
    TTexts.allRecommendedProducts: 'Tous les produits recommandés',
    TTexts.viewAllProducts: 'Voir tous les produits',
    TTexts.recommended: 'Recommandé',
    TTexts.createReview: 'Créer un avis',
    TTexts.createNewReview: 'Créer un nouvel avis',
    TTexts.chooseYourRating: 'Choisissez votre note',
    TTexts.addReview: 'Ajouter un avis',
    TTexts.review: 'Avis',
    TTexts.approved: 'Approuvé',
    TTexts.rejected: 'Rejeté',
    TTexts.searchProducts: 'Rechercher des produits',
    TTexts.results: 'Résultats',
    TTexts.clear: 'Effacer',
    TTexts.alreadyReviewed: 'Ce produit a déjà été évalué par vous.',
    TTexts.productToReview: 'Produit à évaluer',
    TTexts.allReviews: 'Tous les avis',
    TTexts.createNewReviewButton: 'Créer un nouvel avis',
    TTexts.rating: 'Note',
    TTexts.user: 'Utilisateur',
    TTexts.createBanner: "Créer une bannière",
    TTexts.updateBanner: "Mettre à jour la bannière",
    TTexts.allBanners: "Toutes les bannières",
    TTexts.createNewBanner: "Créer une nouvelle bannière",
    TTexts.bannerTitle: "Titre de la bannière",
    TTexts.bannerDescription: "Description",
    TTexts.startDate: "Date de début",
    TTexts.endDate: "Date de fin",
    TTexts.bannerNote:
        "Remarque: Si les dates de début et de fin sont vides, la bannière restera active pour toujours, jusqu'à ce qu'elle soit manuellement marquée comme inactive",
    TTexts.bannerTargetScreen: "Écran cible de la bannière",
    TTexts.bannerTargetType: "Type de cible de bannière",
    TTexts.selectBannerTargetType: "Sélectionner le type de cible de bannière",
    TTexts.customUrl: "URL personnalisée",
    TTexts.shareUrl: "Partagez l'URL que vous souhaitez utiliser.",
    TTexts.selectedItem: "Élément sélectionné",
    TTexts.addSearchKeyword:
        "Ajoutez un mot-clé de recherche et appuyez sur Entrée pour rechercher",
    TTexts.searchBrands: "Rechercher des marques",
    TTexts.searchCategories: "Rechercher des catégories",
    TTexts.views: "Vues",
    TTexts.clicks: "Clics",
    TTexts.couponCode: "Code de coupon",
    TTexts.discountType: "Type de réduction",
    TTexts.discountValue: "Valeur de la réduction",
    TTexts.usageLimit: "Limite d'utilisation",
    TTexts.usageLimitHint: "Nombre de fois que ce coupon peut être utilisé.",
    TTexts.selectDiscountType: "Sélectionner le type de réduction",
    TTexts.couponNote:
        "Remarque: Si les dates de début et de fin sont vides, le coupon restera actif pour toujours, jusqu'à ce qu'il soit manuellement marqué comme inactif",
    TTexts.createCoupon: "Créer un coupon",
    TTexts.updateCoupon: "Mettre à jour le coupon",
    TTexts.coupon: "Coupon",
    TTexts.allCoupons: "Tous les coupons",
    TTexts.createNewCoupon: "Créer un nouveau coupon",
    TTexts.type: "Type",
    TTexts.createNotification: "Créer une notification",
    TTexts.createNewNotification: "Créer une nouvelle notification",
    TTexts.notificationTitle: "Titre de la notification",
    TTexts.notificationDescription: "Description de la notification",
    TTexts.allNotifications: "Toutes les notifications",
    TTexts.notification: "Notification",
    TTexts.notifications: "Notifications",
    TTexts.sent: "Envoyé",
    TTexts.createNotificationHeading: "Créer une nouvelle notification",
    TTexts.notificationType: "Type",
    TTexts.notificationDate: "Date",
    TTexts.notificationAction: "Action",
    TTexts.notificationTableSent: "Envoyé",
    TTexts.notificationTableDate: "Date",
    TTexts.notificationTableType: "Type",
    TTexts.notificationTableAction: "Action",
    TTexts.selectBannerImage: "Sélectionner l'image de la bannière",
    TTexts.chooseStartEndDatesProperly:
        "Choisissez correctement les dates de début et de fin",
    TTexts.bannerCreatedSuccessfully: "Bannière créée avec succès.",
    TTexts.selectProductAsBannerTarget:
        "Sélectionner le produit comme cible de la bannière",
    TTexts.selectCategoryAsBannerTarget:
        "Sélectionner la catégorie comme cible de la bannière",
    TTexts.selectBrandAsBannerTarget:
        "Sélectionner la marque comme cible de la bannière",
    TTexts.addUrlAsBannerTarget: "Ajouter une URL comme cible de la bannière",
    TTexts.unableToFetchBannerDetails:
        "Impossible de récupérer les détails de la bannière. Réessayez.",
    TTexts.selectProductsAsCampaignTarget:
        "Sélectionner des produits comme cible de la campagne",
    TTexts.unableToFetchCouponDetails:
        "Impossible de récupérer les détails du coupon. Réessayez.",
    TTexts.customerInformation: "Informations sur le client",
    TTexts.emailVerified: "E-mail vérifié:",
    TTexts.notVerified: "Non vérifié",
    TTexts.verificationStatus: "État de la vérification:",
    TTexts.lastOrder: "Dernière commande",
    TTexts.noOrdersYet: "Aucune commande pour le moment",
    TTexts.averageOrderValue: "Valeur moyenne de la commande",
    TTexts.registered: "Inscrit",
    TTexts.phoneNumber: "Numéro de téléphone",
    TTexts.shippingAddress: "Adresse de livraison",
    TTexts.name: "Nom",
    TTexts.country: "Pays",
    TTexts.address: "Adresse",
    TTexts.orders: "Commandes",
    TTexts.totalSpent: "Total dépensé",
    TTexts.onOrders: "sur {count} commandes",
    TTexts.searchOrders: "Rechercher des commandes",
    TTexts.noOrdersFound: "Aucune commande trouvée",
    TTexts.allCustomers: "Tous les clients",
    TTexts.profile: "Profil",
    TTexts.profileDetails: "Détails du profil",
    TTexts.updateProfile: "Mettre à jour le profil",
    TTexts.systemSettings: "Paramètres système",
    TTexts.enableTaxShipping: "Activer la taxe et la livraison",
    TTexts.taxRate: "Taux de taxe (%) [par ex., 5% = 0.05]",
    TTexts.taxRateHint:
        "Entrez le taux de taxe sous forme décimale (par ex., 5% = 0.05)",
    TTexts.taxRateHelper: "Le taux de taxe à appliquer. Exemple: 0.05 pour 5%.",
    TTexts.shippingCost: "Frais de livraison",
    TTexts.shippingCostLabel: "Frais de livraison (24)",
    TTexts.shippingCostHelper:
        "Les frais de livraison appliqués à la commande. Exemple: 10 \$.",
    TTexts.freeShippingAfter: "Livraison gratuite après (24)",
    TTexts.freeShippingThreshold: "Seuil de livraison gratuite (24)",
    TTexts.freeShippingThresholdHelper:
        "Le montant minimum de la commande pour la livraison gratuite. Exemple: 50 \$.",
    TTexts.enablePointsSystem: "Activer le système de points",
    TTexts.pointsPerDollarSpent: "Points par dollar dépensé",
    TTexts.pointsPerDollarSpentHint:
        "Entrez les points attribués pour chaque dollar dépensé en achats",
    TTexts.pointsPerDollarSpentHelper:
        "Combien de points le client gagne pour chaque dollar dépensé. Exemple: 10 points par 1 \$.",
    TTexts.pointsToDollarConversion: "Conversion de points en dollars",
    TTexts.pointsToDollarConversionHint:
        "Entrez les points requis pour convertir en 1 dollar",
    TTexts.pointsToDollarConversionHelper:
        "Combien de points sont nécessaires pour échanger 1 dollar. Exemple: 100 points = 1 \$.",
    TTexts.pointsPerRating: "Points par note",
    TTexts.pointsPerRatingHint: "Entrez des points pour chaque note",
    TTexts.pointsPerRatingHelper:
        "Combien de points le client gagne pour chaque note qu'il donne. Exemple: 5 points par note.",
    TTexts.pointsPerReview: "Points par avis",
    TTexts.pointsPerReviewHint: "Entrez des points pour chaque avis",
    TTexts.pointsPerReviewHelper:
        "Combien de points le client gagne pour chaque avis qu'il écrit. Exemple: 20 points par avis.",
    TTexts.settings: "Paramètres",
    TTexts.appSettingsUpdated:
        "Les paramètres de l'application ont été mis à jour.",
    TTexts.unableToFetchCustomerDetails:
        "Impossible de récupérer les détails du client. Réessayez.",
    TTexts.details: "Détails",
    TTexts.verified: "Vérifié",
    TTexts.registerDate: "Date d'inscription",
    TTexts.points: "Points",
    TTexts.yourProfileUpdated: "Votre profil a été mis à jour.",
    TTexts.appNameLabel: "Nom de l'application",
    TTexts.appNameHint: "Entrez le nom de votre application",
    TTexts.updateProfileButton: "Mettre à jour le profil",
    TTexts.breadcrumbSettings: "Paramètres",
    TTexts.itemsCount: "{count} articles",
    TTexts.selectBrandForProduct: 'Sélectionnez la marque pour ce produit',
    TTexts.createProductSuccessTitle: 'Produit créé',
    TTexts.createProductSuccessMessage: 'Votre produit a été créé avec succès.',
    TTexts.searchProductsNote:
        'Recherchez des produits en utilisant leur nom réel tel qu\'il est stocké dans la base de données ou en utilisant les balises qui leur sont attribuées. Appuyez sur Entrée pour rechercher.',
    TTexts.yourRecordHasBeenUpdated: 'Votre enregistrement a été mis à jour.',
    TTexts.selectBannerImage: 'Sélectionner l\'image de la bannière',
    TTexts.chooseStartEndDatesProperly:
        'Choisissez correctement les dates de début et de fin',
    TTexts.selectProductAsBannerTarget:
        'Sélectionner le produit comme cible de la bannière',
    TTexts.selectCategoryAsBannerTarget:
        'Sélectionner la catégorie comme cible de la bannière',
    TTexts.selectBrandAsBannerTarget:
        'Sélectionner la marque comme cible de la bannière',
    TTexts.addUrlAsBannerTarget: 'Ajouter une URL comme cible de la bannière',
    TTexts.customUrl: 'URL personnalisée',
    TTexts.newRecordAdded: 'Nouvel enregistrement ajouté',
    TTexts.selectProductsAsCampaignTarget:
        'Sélectionner des produits comme cible de la campagne',
    TTexts.unableToFetchCouponDetails:
        'Impossible de récupérer les détails du coupon. Réessayez.',
    TTexts.addColor: 'Ajouter une couleur',
    TTexts.selectedColors: 'Couleurs sélectionnées',
    TTexts.yourSelectedColorsWillBeDisplayedHere:
        'Vos couleurs sélectionnées seront affichées ici.',
    TTexts.longPressToDeleteColor:
        'Appuyez longuement pour supprimer la couleur ajoutée de la liste.',
    TTexts.attributeName: 'Nom de l\'attribut',
    TTexts.attributeNameTooltip:
        'Spécifiez le nom de l\'attribut, tel que \'Taille\', \'Couleur\' ou \'Matériau\'. Cela aide à catégoriser et à organiser efficacement vos options de produits.',
    TTexts.isThisAColorField: 'Est-ce un champ de couleur?',
    TTexts.isThisAColorFieldTooltip:
        'Si vous souhaitez ajouter des couleurs, choisissez cette option pour ajouter des couleurs.',
    TTexts.attributeValues: 'Valeurs d\'attribut',
    TTexts.modelsField: 'Champ Modèles',
    TTexts.attributeValuesHint:
        'Ajoutez des attributs séparés par | Exemple: Petit | Moyen | Grand',
    TTexts.attributeValuesTooltip:
        'Énumérez les valeurs possibles pour cet attribut, séparées par \' | \'. Par exemple: \'Petit | Moyen | Grand\' ou \'Rouge | Bleu | Vert\'.',
    TTexts.searchable: 'Recherchable',
    TTexts.sortable: 'Triable',
    TTexts.searchableTooltip:
        'Marquez cet attribut comme consultable, permettant aux utilisateurs de filtrer les produits en fonction de cet attribut. Par exemple, l\'activation de cette option permet aux utilisateurs de rechercher par nom d\'attribut.',
    TTexts.sortableTooltip:
        'Si vous souhaitez que les produits soient triés par cet attribut (par ex., par prix, taille ou couleur), activez cette option pour permettre aux clients de trier les articles en conséquence.',
    TTexts.attribute: 'Attribut',
    TTexts.values: 'Valeurs',

    // -- Brand Management
    TTexts.createBrand: "Créer une marque",
    TTexts.createNewBrand: "Créer une nouvelle marque",
    TTexts.updateBrand: "Mettre à jour la marque",
    TTexts.allBrands: "Toutes les marques",
    TTexts.brandName: "Nom de la marque",
    TTexts.selectCategories: "Sélectionner des catégories",
    TTexts.noCategoriesFound: "Aucune catégorie trouvée",
    TTexts.categories: "Catégories",
    TTexts.brandCreated: "Marque créée",
    TTexts.brandUpdated: "Marque mise à jour",
    TTexts.brandDeleteError:
        "Impossible de supprimer cette marque. Modifiez ou dissociez tous les produits associés à cette marque avant de la supprimer.",

    // -- Category Management
    TTexts.createCategory: "Créer une catégorie",
    TTexts.createNewCategory: "Créer une nouvelle catégorie",
    TTexts.updateCategory: "Mettre à jour la catégorie",
    TTexts.allCategories: "Toutes les catégories",
    TTexts.categoryName: "Nom de la catégorie",
    TTexts.wantToCreateSubCategory: "Voulez-vous créer une sous-catégorie?",
    TTexts.wantToCreateCategory: "Voulez-vous créer une catégorie?",
    TTexts.createSubCategory: "Créer une sous-catégorie",
    TTexts.createNewSubCategory: "Créer une nouvelle sous-catégorie",
    TTexts.updateSubCategory: "Mettre à jour la sous-catégorie",
    TTexts.subCategoryName: "Nom de la sous-catégorie",
    TTexts.parentCategory: "Catégorie parente",
    TTexts.noParentCategories: "Aucune catégorie parente",
    TTexts.subCategoriesList: "Liste des sous-catégories",
    TTexts.allSubCategories: "Toutes les sous-catégories",
    TTexts.subCategory: "Sous-catégorie",
    TTexts.createSubCategoryButton: "Créer une sous-catégorie",
    TTexts.category: "Catégorie",
    TTexts.categoryCreated: "Catégorie créée",
    TTexts.categoryUpdated: "Catégorie mise à jour",
    TTexts.subCategoryCreated: "Sous-catégorie créée",
    TTexts.subCategoryUpdated: "Sous-catégorie mise à jour",
    TTexts.categoryDeleteError:
        "Impossible de supprimer cette catégorie. Modifiez ou dissociez tous les produits associés à cette catégorie avant de la supprimer.",
    TTexts.subcategoriesExistError:
        "Des sous-catégories existent sous cette catégorie. Veuillez les supprimer d'abord.",
    TTexts.chooseParentForSubCategory:
        "Pour créer une sous-catégorie, choisissez un parent.",
    TTexts.parentCategoryEmpty: "La catégorie parente ne peut pas être vide",
    TTexts.invalidFormDetails: "Détails du formulaire non valides",

    // -- Unit Management
    TTexts.createUnit: "Créer une unité",
    TTexts.createNewUnit: "Créer une nouvelle unité",
    TTexts.updateUnit: "Mettre à jour l'unité",
    TTexts.allUnits: "Toutes les unités",
    TTexts.unitName: "Nom de l'unité",
    TTexts.unitNameTooltip:
        "Entrez un nom descriptif pour l'unité de mesure, tel que Longueur, Poids, Largeur ou Hauteur, pour spécifier le type d'attribut.",
    TTexts.unitAbbreviation: "Abréviation de l'unité",
    TTexts.unitAbbreviationTooltip:
        "Fournissez une abréviation concise pour l'unité, telle que 'kg' pour kilogrammes ou 'cm' pour centimètres, pour garantir la clarté et l'uniformité d'utilisation.",
    TTexts.selectType: "Sélectionner le type",
    TTexts.selectAUnitType: "Sélectionner un type d'unité",
    TTexts.noUnitTypesFound: "Aucun type d'unité trouvé",
    TTexts.conversionFactor: "Facteur de conversion",
    TTexts.conversionFactorTooltip:
        "Spécifiez le facteur numérique utilisé pour convertir cette unité en unité de base. Par exemple, si l'unité de base est le mètre, le facteur de conversion pour les centimètres serait de 0.01.",
    TTexts.searchableKeywords: "Mots-clés consultables",
    TTexts.unitValues: "Valeurs d'unité",
    TTexts.unitValuesHint:
        "Ajoutez des unités séparées par | Exemple: Petit | Moyen | Grand",
    TTexts.unitValuesTooltip:
        "Entrez une liste de valeurs représentant cette unité, séparées par un délimiteur, pour définir la plage ou les options disponibles pour cet attribut.",
    TTexts.baseUnit: "Unité de base",
    TTexts.baseUnitTooltip:
        "Sélectionnez ou définissez l'unité de mesure principale à laquelle toutes les autres unités de cette catégorie seront normalisées ou converties.",
    TTexts.unit: "Unité",
    TTexts.abbreviation: "Abréviation",
    TTexts.unitCreated: "Unité créée",
    TTexts.unitUpdated: "Unité mise à jour",

    // -- Attribute Management
    TTexts.attributeCreated: "Attribut créé",
    TTexts.attributeUpdated: "Attribut mis à jour",

    // -- Data Table
    TTexts.recordNotFound: "Enregistrement non trouvé",
    TTexts.unableToSwitch: "Impossible de changer",
    TTexts.delete: "Supprimer",
    TTexts.itemDeleted: "Article supprimé",
    TTexts.yourItemHasBeenDeleted: "Votre article a été supprimé",
    TTexts.itemNotDeleted: "Article non supprimé",
    TTexts.areYouSureYouWantToDeleteThisItem:
        "Êtes-vous sûr de vouloir supprimer cet article?",
    TTexts.youAreNotAuthorizedToDeleteThisItem:
        "Vous n'êtes pas autorisé à supprimer cet article.",

    // -- Address
    TTexts.somethingWentWrongFetchingAddressInformation:
        "Quelque chose s'est mal passé lors de la récupération des informations d'adresse. Réessayez plus tard",
    TTexts.unableToUpdateYourAddressSelection:
        "Impossible de mettre à jour votre sélection d'adresse. Réessayez plus tard",
    TTexts.somethingWentWrongSavingAddressInformation:
        "Quelque chose s'est mal passé lors de l'enregistrement des informations d'adresse. Réessayez plus tard",

    // -- Sidebar
    TTexts.sidebarOverviewMedia: "APERÇU ET MÉDIAS",
    TTexts.sidebarDataManagement: "GESTION DES DONNÉES",
    TTexts.sidebarCategories: "Catégories",
    TTexts.sidebarSubCategories: "Sous-catégories",
    TTexts.sidebarBrands: "Marques",
    TTexts.sidebarAttributes: "Attributs",
    TTexts.sidebarUnits: "Unités",
    TTexts.sidebarProductManagement: "GESTION DES PRODUITS",
    TTexts.sidebarAddNewProduct: "Ajouter un nouveau produit",
    TTexts.sidebarProducts: "Produits",
    TTexts.sidebarRecommendedProducts: "Produits recommandés",
    TTexts.sidebarCustomers: "Clients",
    TTexts.sidebarOrders: "Commandes",
    TTexts.sidebarProductReviews: "Avis sur les produits",
    TTexts.sidebarRetailerManagement: "GESTION DES DÉTAILLANTS",
    TTexts.sidebarAddNewRetailer: "Ajouter un nouveau détaillant",
    TTexts.sidebarAllRetailers: "Tous les détaillants",
    TTexts.sidebarPromotionManagement: "GESTION DES PROMOTIONS",
    TTexts.sidebarBanners: "Bannières",
    TTexts.sidebarCoupons: "Bons de réduction",
    TTexts.sidebarNotification: "NOTIFICATION",
    TTexts.sidebarNotifications: "Notifications",
    TTexts.sidebarSupportManagement: "GESTION DU SUPPORT",
    TTexts.sidebarChat: "Chat",
    TTexts.sidebarConfigurations: "CONFIGURATIONS",
    TTexts.sidebarProfile: "Profil",
    TTexts.sidebarAppSettings: "Paramètres de l'application",
    TTexts.sidebarLogout: "Déconnexion",

    // -- Retailer Table
    TTexts.retailerCreateNew: "Créer un nouveau détaillant",
    TTexts.retailerTableHeadingRetailer: "Détaillant",
    TTexts.retailerTableHeadingShop: "Boutique",
    TTexts.retailerTableHeadingVerification: "Vérification",
    TTexts.retailerTableHeadingIds: "ID's",
    TTexts.retailerTableHeadingFeatured: "En vedette",
    TTexts.retailerTableHeadingStatus: "Statut",
    TTexts.retailerTableHeadingDate: "Date",
    TTexts.retailerTableHeadingAction: "Action",
    TTexts.retailerTaxId: "N° fiscal: ",
    TTexts.retailerRegNo: "N° d'enreg.: ",
    TTexts.productRetailerShop: "Détaillant / Boutique du produit",
    TTexts.selectRetailer: "Sélectionner un détaillant",
    TTexts.chooseRetailer: "Choisissez un détaillant",
    TTexts.selectedRetailerShop: "Détaillant / Boutique sélectionné(e)",
  };
}
