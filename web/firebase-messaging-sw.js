importScripts("https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.0/firebase-messaging-compat.js");
firebase.initializeApp({
  apiKey: "AIzaSyBZGGpRBIEPF0q3TF5DURFb0B9KGvJefIw",
  authDomain: "radiology-and-lab-app.firebaseapp.com",
  projectId: "radiology-and-lab-app",
  storageBucket: "radiology-and-lab-app.firebasestorage.app",
  messagingSenderId: "132466130127",
  appId: "1:132466130127:web:57b4f37cc7f2b750ce4bba"
});
const messaging = firebase.messaging();
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
});
