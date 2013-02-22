import tkSimpleDialog
from Tkinter import *

class ActDialog(Toplevel):

    def __init__(self, parent, act):
        Toplevel.__init__(self,parent)
        self.parent = parent
        self.transient(parent)
        self.title("Select activity")
        self.items = [ a for a in act.actNames if a != "" and a != "NA" ]
        self.sel = None

        body = Frame(self)
        self.initial_focus = self.body(body)
        body.pack(padx=5,pady=5)
        self.buttonbox()
        self.grab_set()
        if not self.initial_focus:
            self.initial_focus = self
        self.protocol("WM_DELETE_WINDOW",self.cancel)
        self.geometry("+%d+%d" % (parent.winfo_rootx()+50,
                                  parent.winfo_rooty()+50))
        self.initial_focus.focus_set()
        self.wait_window(self)
    
    def body(self, master):
        Label(master, text="Activity:").grid(row=0)
        self.e1 = Listbox(master)
        self.e1.grid(row=0, column=1)
        self.e1.delete(0,END)
        for item in self.items:
            self.e1.insert(END,item)
        return self.e1 # initial focus

    def apply(self):
        items = self.e1.curselection()
        self.sel = self.items[int(items[0])]

    def getSelection(self):
        return self.sel

    def buttonbox(self):
        box = Frame(self)

        w = Button(box, text="OK", width=10, command=self.ok, default=ACTIVE)
        w.pack(side=LEFT, padx=5, pady=5)
        w = Button(box, text="Cancel", width=10, command=self.cancel)
        w.pack(side=LEFT, padx=5, pady=5)

        self.bind("<Return>", self.ok)
        self.bind("<Escape>", self.cancel)

        box.pack()

    #
    # standard button semantics

    def ok(self, event=None):

        if not self.validate():
            self.initial_focus.focus_set() # put focus back
            return

        self.withdraw()
        self.update_idletasks()

        self.apply()
        self.cancel()

    def cancel(self, event=None):
        # put focus back to the parent window
        self.parent.focus_set()
        self.destroy()

    def validate(self):
        return True # override


    
