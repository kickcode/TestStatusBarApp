Villain = Struct.new(:name, :alias, :description)
VILLAINS = [
  Villain.new("The Joker", "Mr. J", "The Joker possesses no superhuman abilities, instead using his expertise in chemical engineering to develop poisonous or lethal concoctions, and thematic weaponry."),
  Villain.new("The Penguin", "Mr. Cobblepot", "The Penguin is depicted as being short and portly, and he is known for his love of birds and his specialized high-tech umbrellas."),
  Villain.new("Two-Face", "Harvey Dent", "Once a clean-cut district attorney of Gotham City and an ally of Batman, Harvey Dent goes insane after a mob boss throws acid at him during a trial, hideously scarring the left side of his face."),
  Villain.new("Bane", "N/A", "Known for his brute physical strength, the character is often credited as being the only villain to have 'Broken the Bat.'"),
  Villain.new("The Riddler", "Edward Nigma", "The Riddler is typically portrayed as a smooth-talking yet quirky character, motivated by a neurotic compulsion to commit crimes based on riddles and puzzles."),
  Villain.new("Deadshot", "Floyd Lawton", "He is capable of using a large variety of weapons, but is most frequently portrayed as using a pair of silenced, wrist-mounted guns."),
  Villain.new("Deathstroke", "Slade Wilson", "Chosen for a secret experiment, the Army imbued him with enhanced physical powers in an attempt to create metahuman supersoldiers for the U.S. military."),
  Villain.new("Poison Ivy", "Dr. Pamela Isley", "She begins her criminal career by threatening to release her suffocating spores into the air unless the city meets her demands."),
  Villain.new("Scarecrow", "Dr. Jonathan Crane", "Crane's obsession with fear leads to his becoming a psychiatrist, taking a position at Arkham Asylum and performing fear-inducing experiments on his patients.")
]

class VillainView < NSView
  def initWithFrame(rect)
    super(NSMakeRect(rect.origin.x, rect.origin.y, AppDelegate::POPUP_WIDTH, 100))

    @box = NSBox.alloc.initWithFrame(NSInsetRect(self.bounds, 5, 3))
    self.addSubview(@box)

    @description = NSTextField.alloc.initWithFrame(NSMakeRect(0, -30, @box.frame.size.width, 100))
    @description.drawsBackground = false
    @description.setEditable false
    @description.setSelectable false
    @description.setBezeled false
    @box.addSubview(@description)

    self
  end

  def setViewObject(object)
    return if object.nil?
    @box.title = "#{object.name} (also known as: #{object.alias})"
    @description.stringValue = object.description
    @object = object
  end

  def mouseDown(event)
    alert = NSAlert.alloc.init
    alert.setMessageText "You clicked on: #{@object.name}"
    alert.addButtonWithTitle "OK"
    alert.runModal
  end
end

class VillainPrototype < NSCollectionViewItem
  def loadView
    self.setView(VillainView.alloc.initWithFrame(NSZeroRect))
  end

  def setRepresentedObject(object)
    super(object)
    self.view.setViewObject(object)
  end
end