#!/usr/bin/python
# Filename: knotify.py
import sys, os, argparse, dbus, io


#type: warning, notification, fatalerror, messageInformation
# source : /usr/share/apps/kde/kde.notifyrc
  

def notify(title, text, pixmap, timeout):
    knotify = dbus.SessionBus().get_object("org.kde.knotify", "/Notify")
    knotify.event(
                "notification",#"notification", 
                  'kde', [], title, text, 
                  pixmap, # [],
                  [], 
                  timeout, # duree de vie
                  0, 
                  dbus_interface="org.kde.KNotify")
    
class mainApp(object):
    
   
    def __init__(self):
        self._icon= []
        self.duration= 0
        self.title = "notification"
        self.message = ""
        
    def getArguments(self):
        parser = argparse.ArgumentParser(description="Send KDE notitication")
        parser.add_argument("title",          help="titre de la notification")
        parser.add_argument("-m",   "--message",    help="message a afficher")
        parser.add_argument("-i",   "--icon",   default=".face.icon",    help="fichier icone")
        parser.add_argument("-d",   "--duration",   default=0,    help="durée d'affichage")
        return parser
    
    def injection(self, args):
        args = parser.parse_args()
        if (args.title):
            self.title=args.title
        if (args.message):
            self.message=args.message
        if (args.duration):
            self.duration=int(args.duration)*1000
        if (args.icon):
            fileName= args.icon
            if (os.path.isfile(fileName)!=True):
                raise FileExistsError('Icon File not found: '+fileName )
                #filename='/home/patrick/.face.icon'
            f = open(fileName, 'rb')
            self._icon = f.read()
            f.close()
                
    def run(self):
        notify(self.title, self.message, self._icon, self.duration)
    
    
if __name__ == '__main__':
    
    app= mainApp()
    parser= app.getArguments()
    app.injection(parser)
    app.run()
