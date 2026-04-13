include( "shared.lua" )

function ENT:Initialize()
    self:EnableCustomCollisions( true )

    local selfTable = self:GetTable()
    selfTable.shield_OldSkin = nil
    selfTable.shield_TextureScale = nil
end

local topOffset = Vector(0, 0, 190)
local SHIELD_MATERIAL = Material("effects/combineshield/comshieldwall3")

function ENT:Draw()
    if ( self:GetSkin() != 0 ) then return end

    local dummyStart = self:GetDummyStart()
    local dummyEnd = self:GetDummyEnd()

    local selfTable = self:GetTable()

    if ( !IsValid(dummyStart) or !IsValid(dummyEnd) ) then return end

    local startsPos = dummyStart:GetPos()
    local endsPos = dummyEnd:GetPos()

    local startsUp = dummyStart:GetUp()
    local endsUp = dummyEnd:GetUp()

    local dist = startsPos:Distance( endsPos )
    local texScale = selfTable.shield_TextureScale or ( dist / 75 )
    if ( !selfTable.oldtexscale or selfTable.oldtexscale != texScale ) then
        selfTable.oldtexscale = texScale
    end

    -- draw fake shield, from start dummy to end dummy.
    local matrix = Matrix()
    -- move to base of shield.
    matrix:Translate( startsPos + startsUp * -40 )
    -- use shield's angles
    matrix:SetAngles( dummyStart:GetAngles() )

    local startBottom = vector_origin
    local startTop = topOffset
    local endBottom = dummyStart:WorldToLocal( endsPos )
    local endTop = dummyStart:WorldToLocal( endsPos + endsUp * 190 )
    self:SetRenderBounds( -startsUp * 150, endBottom + startsUp * 150 )

    render.SetMaterial( SHIELD_MATERIAL )
    cam.PushModelMatrix( matrix )
        self:DrawShield( startBottom, startTop, endBottom, endTop, texScale )
    cam.PopModelMatrix()


    -- draw second one, starting from the end dummy, to the start dummy
    matrix = Matrix()
    -- move to base of shield.
    matrix:Translate( endsPos + endsUp * -40 )
    matrix:SetAngles( dummyEnd:GetAngles() )

    startBottom = dummyEnd:WorldToLocal( startsPos )
    startTop = dummyEnd:WorldToLocal( startsPos + startsUp * 190 )
    endBottom = vector_origin
    endTop = topOffset

    cam.PushModelMatrix( matrix )
        self:DrawShield( endBottom, endTop, startBottom, startTop, texScale )
    cam.PopModelMatrix()
end

local vertScale = 3

function ENT:DrawShield( startBottom, startTop, endBottom, endTop, scale )
    mesh.Begin( MATERIAL_TRIANGLES, 2 )
        mesh.Position( startBottom )
        mesh.TexCoord( 0, 0, 0 )
        mesh.AdvanceVertex()

        mesh.Position( startTop )
        mesh.TexCoord( 0, 0, vertScale )
        mesh.AdvanceVertex()

        mesh.Position( endTop )
        mesh.TexCoord( 0, scale, vertScale )
        mesh.AdvanceVertex()

        mesh.Position( endTop )
        mesh.TexCoord( 0, scale, vertScale )
        mesh.AdvanceVertex()

        mesh.Position( endBottom )
        mesh.TexCoord( 0, scale, 0 )
        mesh.AdvanceVertex()

        mesh.Position( startBottom )
        mesh.TexCoord( 0, 0, 0 )
        mesh.AdvanceVertex()
    mesh.End()
end

function ENT:Think()
    local mySkin = self:GetSkin()
    local selfTable = self:GetTable()
    if ( selfTable.shield_OldSkin == mySkin ) then return end

    if ( !self:DoShieldCollisions() ) then return end -- not ready

    selfTable.shield_TextureScale = nil
    selfTable.shield_OldSkin = mySkin
end
