local MODULE = MODULE

MODULE.Name = "Custom Module"
MODULE.Ddescription = "Adds custom functionality to the HL2RP schema."
MODULE.Author = "YourName"

function MODULE:PostInitializeModule()
    ax.util:Print("Custom Module has been loaded.")
end