local MODULE = MODULE

MODULE.name = "Custom Module"
MODULE.description = "Adds custom functionality to the HL2RP schema."
MODULE.author = "YourName"

function MODULE:PostInitializeModule()
    ax.util:Print("Custom Module has been loaded.")
end
