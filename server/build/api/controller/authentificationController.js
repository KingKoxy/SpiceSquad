"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const abstractController_1 = __importDefault(require("./abstractController"));
const firebaseAuth = require("firebase/auth");
const firebase = require("firebase/app");
const firebaseAdmin = require("firebase-admin");
class AuthentificationController extends abstractController_1.default {
    constructor() {
        super();
        this.firebaseConfig = {
            apiKey: process.env.FB_API_KEY,
            authDomain: process.env.FB_AUTH_DOMAIN,
            databaseURL: process.env.FB_DATABASE_URL,
            projectId: process.env.FB_PROJECT_ID,
            storageBucket: process.env.FB_STORAGE_BUCKET,
            messagingSenderId: process.env.FB_MESSAGING_SENDER_ID,
            appId: process.env.FB_APP_ID
        };
        firebase.initializeApp(this.firebaseConfig);
        this.auth = firebaseAuth.getAuth();
    }
    userLogin(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            firebaseAuth.signInWithEmailAndPassword(this.auth, req.body.email, req.body.password)
                .then((userCredentials) => __awaiter(this, void 0, void 0, function* () {
                console.log('Successfully logged in:', userCredentials.user);
                res.status(200).json({
                    refreshToken: userCredentials.user.refreshToken,
                    idToken: yield firebaseAuth.getIdToken(userCredentials.user)
                });
            })).catch((error) => {
                switch (error.code) {
                    case 'auth/invalid-email':
                        res.status(409).json({
                            error: "The email address is not valid.",
                        });
                        break;
                    case 'auth/user-disabled':
                        res.status(409).json({
                            error: "The user corresponding to the given email has been disabled.",
                        });
                        break;
                    case 'auth/user-not-found':
                        res.status(409).json({
                            error: "There is no user corresponding to the given email.",
                        });
                        break;
                    case 'auth/wrong-password':
                        res.status(409).json({
                            error: "The password is invalid for the given email.",
                        });
                        break;
                    default:
                        res.status(409).json({
                            error: "An error occurred.",
                        });
                        break;
                }
                ;
            });
        });
    }
    userRegister(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            firebaseAuth.createUserWithEmailAndPassword(this.auth, req.body.email, req.body.password)
                .then((userCredentials) => __awaiter(this, void 0, void 0, function* () {
                console.log('Successfully created new user:', userCredentials.user);
                this.pool.query('INSERT INTO "user" (user_name, email, firebase_user_id, created_groups) VALUES ($1, $2, $3, $4)', [req.body.user_name, req.body.email, userCredentials.user.uid, 0]);
                res.status(200).json({
                    refreshToken: userCredentials.user.refreshToken,
                    idToken: yield firebaseAuth.getIdToken(userCredentials.user)
                });
            }))
                .catch((error) => {
                switch (error.code) {
                    case 'auth/email-already-in-use':
                        res.status(409).json({
                            error: 'The email address is already in use',
                        });
                        break;
                    case 'auth/invalid-email':
                        res.status(200).json({
                            error: "The email address is not valid.",
                        });
                        break;
                    case 'auth/operation-not-allowed':
                        res.status(200).json({
                            error: "The operation is not allowed.",
                        });
                        break;
                    case 'auth/weak-password':
                        res.status(200).json({
                            error: "The password is not strong enough.",
                        });
                        break;
                    default:
                        res.status(200).json({
                            error: "An error occurred.",
                        });
                        break;
                }
            });
        });
    }
    userResetPassword(req, res) {
        firebaseAuth.sendPasswordResetEmail(this.auth, req.body.email)
            .then(() => {
            res.status(200).json({
                message: "Email sent",
            });
        }).catch((error) => {
            switch (error.code) {
                case 'auth/invalid-email':
                    res.status(200).json({
                        error: "The email address is not valid.",
                    });
                    break;
                default:
                    res.status(200).json({
                        error: "An error occurred.",
                    });
                    break;
            }
        });
    }
    ;
    getUserByToken(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            firebaseAuth.signInWithCredential(this.auth, req.body.refreshToken)
                .then((userCredentials) => __awaiter(this, void 0, void 0, function* () {
                console.log('Successfully logged in:', userCredentials.user);
                res.status(200).json({
                    idToken: yield firebaseAuth.getIdToken(userCredentials.user)
                    // TODO: Add user data
                });
            }));
        });
    }
    userRefreshToken(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            firebaseAdmin.auth().verifyIdToken(req.body.refreshToken)
                .then((sessionCookie) => __awaiter(this, void 0, void 0, function* () {
                console.log('Successfully logged in:', sessionCookie);
                res.status(200).json({
                    idToken: sessionCookie
                });
            }));
        });
    }
    userLogout(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            firebaseAuth.signOut(this.auth)
                .then(() => {
                res.status(200).json({
                    message: "Successfully logged out",
                });
            });
        });
    }
}
exports.default = AuthentificationController;
//# sourceMappingURL=authentificationController.js.map